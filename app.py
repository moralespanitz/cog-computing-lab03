from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
from werkzeug.security import check_password_hash, generate_password_hash
import os
from dotenv import load_dotenv
from functools import wraps

# Load environment variables
load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('FLASK_SECRET_KEY', 'dev-secret-key-change-in-production')

# MySQL Configuration
app.config['MYSQL_HOST'] = os.getenv('MYSQL_HOST', 'localhost')
app.config['MYSQL_USER'] = os.getenv('MYSQL_USER', 'root')
app.config['MYSQL_PASSWORD'] = os.getenv('MYSQL_PASSWORD', '')
app.config['MYSQL_DB'] = os.getenv('MYSQL_DB', 'user_management')
app.config['MYSQL_PORT'] = int(os.getenv('MYSQL_PORT', 3306))

mysql = MySQL(app)


# Decorator to require login
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'logged_in' not in session:
            flash('Por favor inicie sesión para acceder a esta página.', 'warning')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function


@app.route('/')
def index():
    """Redirect to login page"""
    return redirect(url_for('login'))


@app.route('/login', methods=['GET', 'POST'])
def login():
    """Login page"""
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        if not username or not password:
            flash('Por favor ingrese usuario y contraseña.', 'danger')
            return render_template('login.html')

        # Query admin user
        cur = mysql.connection.cursor()
        cur.execute("SELECT id, username, password FROM admin_users WHERE username = %s", (username,))
        user = cur.fetchone()
        cur.close()

        if user and check_password_hash(user[2], password):
            session['logged_in'] = True
            session['user_id'] = user[0]
            session['username'] = user[1]
            flash('¡Inicio de sesión exitoso!', 'success')
            return redirect(url_for('dashboard'))
        else:
            flash('Usuario o contraseña incorrectos.', 'danger')

    return render_template('login.html')


@app.route('/logout')
def logout():
    """Logout user"""
    session.clear()
    flash('Ha cerrado sesión correctamente.', 'info')
    return redirect(url_for('login'))


@app.route('/dashboard')
@login_required
def dashboard():
    """Dashboard with user list"""
    cur = mysql.connection.cursor()
    cur.execute("SELECT id, nombre, email, rol, created_at FROM users ORDER BY id DESC")
    users = cur.fetchall()
    cur.close()

    return render_template('dashboard.html', users=users)


@app.route('/user/create', methods=['GET', 'POST'])
@login_required
def create_user():
    """Create new user"""
    if request.method == 'POST':
        nombre = request.form.get('nombre', '').strip()
        email = request.form.get('email', '').strip()
        rol = request.form.get('rol', 'usuario')

        # Validation
        if not nombre or not email:
            flash('El nombre y el email son obligatorios.', 'danger')
            return render_template('create_user.html')

        if rol not in ['admin', 'usuario']:
            flash('El rol debe ser "admin" o "usuario".', 'danger')
            return render_template('create_user.html')

        try:
            cur = mysql.connection.cursor()
            cur.execute(
                "INSERT INTO users (nombre, email, rol) VALUES (%s, %s, %s)",
                (nombre, email, rol)
            )
            mysql.connection.commit()
            cur.close()
            flash(f'Usuario "{nombre}" creado exitosamente.', 'success')
            return redirect(url_for('dashboard'))
        except Exception as e:
            flash(f'Error al crear usuario: {str(e)}', 'danger')
            return render_template('create_user.html')

    return render_template('create_user.html')


@app.route('/user/edit/<int:user_id>', methods=['GET', 'POST'])
@login_required
def edit_user(user_id):
    """Edit existing user"""
    cur = mysql.connection.cursor()

    if request.method == 'POST':
        nombre = request.form.get('nombre', '').strip()
        email = request.form.get('email', '').strip()
        rol = request.form.get('rol', 'usuario')

        # Validation
        if not nombre or not email:
            flash('El nombre y el email son obligatorios.', 'danger')
            cur.execute("SELECT id, nombre, email, rol FROM users WHERE id = %s", (user_id,))
            user = cur.fetchone()
            cur.close()
            return render_template('edit_user.html', user=user)

        if rol not in ['admin', 'usuario']:
            flash('El rol debe ser "admin" o "usuario".', 'danger')
            cur.execute("SELECT id, nombre, email, rol FROM users WHERE id = %s", (user_id,))
            user = cur.fetchone()
            cur.close()
            return render_template('edit_user.html', user=user)

        try:
            cur.execute(
                "UPDATE users SET nombre = %s, email = %s, rol = %s WHERE id = %s",
                (nombre, email, rol, user_id)
            )
            mysql.connection.commit()
            cur.close()
            flash(f'Usuario actualizado exitosamente.', 'success')
            return redirect(url_for('dashboard'))
        except Exception as e:
            flash(f'Error al actualizar usuario: {str(e)}', 'danger')
            cur.close()
            return redirect(url_for('edit_user', user_id=user_id))

    # GET request - show form
    cur.execute("SELECT id, nombre, email, rol FROM users WHERE id = %s", (user_id,))
    user = cur.fetchone()
    cur.close()

    if not user:
        flash('Usuario no encontrado.', 'danger')
        return redirect(url_for('dashboard'))

    return render_template('edit_user.html', user=user)


@app.route('/user/delete/<int:user_id>', methods=['POST'])
@login_required
def delete_user(user_id):
    """Delete user"""
    try:
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM users WHERE id = %s", (user_id,))
        mysql.connection.commit()
        cur.close()
        flash('Usuario eliminado exitosamente.', 'success')
    except Exception as e:
        flash(f'Error al eliminar usuario: {str(e)}', 'danger')

    return redirect(url_for('dashboard'))


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
