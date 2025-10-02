# Sistema de Gestión de Usuarios - Flask + MySQL

Aplicación web desarrollada con Flask que implementa un sistema completo de autenticación y CRUD (Crear, Leer, Actualizar, Eliminar) para gestión de usuarios.

## 📋 Características

- **Sistema de Login (10 puntos)**
  - Autenticación de usuarios con validación de credenciales
  - Sesiones seguras con Flask
  - Mensajes de error informativos
  - Redirección automática al dashboard

- **CRUD de Usuarios (10 puntos)**
  - ✅ **Crear**: Formulario para registrar nuevos usuarios con validación
  - 📖 **Leer**: Listado completo de usuarios en tabla interactiva
  - ✏️ **Actualizar**: Edición de datos de usuarios existentes
  - 🗑️ **Eliminar**: Eliminación con confirmación modal

## 🛠️ Tecnologías Utilizadas

- **Backend**: Flask 3.0+
- **Base de Datos**: MySQL 8.0
- **Gestión de Paquetes**: UV (Package Manager)
- **Containerización**: Docker & Docker Compose
- **Frontend**: Bootstrap 5.3, Bootstrap Icons
- **Seguridad**: Werkzeug (password hashing)

## 📁 Estructura del Proyecto

```
lab03/
├── app.py                  # Aplicación principal Flask
├── pyproject.toml          # Configuración de dependencias (UV)
├── Dockerfile              # Imagen Docker de la aplicación
├── docker-compose.yml      # Orquestación de servicios
├── .env.example            # Plantilla de variables de entorno
├── .gitignore              # Archivos ignorados por Git
├── database/
│   └── init.sql           # Script de inicialización de BD
├── templates/
│   ├── base.html          # Plantilla base
│   ├── login.html         # Página de login
│   ├── dashboard.html     # Lista de usuarios
│   ├── create_user.html   # Formulario de creación
│   └── edit_user.html     # Formulario de edición
└── README.md              # Este archivo
```

## 🚀 Instalación y Ejecución

### Opción 1: Usando Docker (Recomendado)

#### Requisitos Previos
- Docker Desktop instalado
- Docker Compose instalado

#### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd lab03
   ```

2. **Construir y levantar los contenedores**
   ```bash
   docker-compose up --build
   ```

3. **Acceder a la aplicación**
   - Abrir el navegador en: http://localhost:5001
   - Usuario: `admin`
   - Contraseña: `admin123`

4. **Detener la aplicación**
   ```bash
   docker-compose down
   ```

5. **Detener y eliminar volúmenes** (limpieza completa)
   ```bash
   docker-compose down -v
   ```

### Opción 2: Instalación Local con UV

#### Requisitos Previos
- Python 3.11+
- MySQL 8.0 instalado y corriendo
- UV package manager instalado (`pip install uv`)

#### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd lab03
   ```

2. **Configurar MySQL**
   ```bash
   # Iniciar sesión en MySQL
   mysql -u root -p

   # Ejecutar el script de inicialización
   source database/init.sql
   ```

3. **Configurar variables de entorno**
   ```bash
   cp .env.example .env
   # Editar .env con tus credenciales de MySQL
   ```

4. **Instalar dependencias con UV**
   ```bash
   uv pip install -r pyproject.toml
   ```

5. **Ejecutar la aplicación**
   ```bash
   python app.py
   ```

6. **Acceder a la aplicación**
   - Abrir el navegador en: http://localhost:5001
   - Usuario: `admin`
   - Contraseña: `admin123`

## 🔐 Credenciales por Defecto

### Usuario Administrador (Login)
- **Usuario**: `admin`
- **Contraseña**: `admin123`

### Usuarios de Prueba (CRUD)
La base de datos incluye 4 usuarios de ejemplo:
1. Juan Pérez - juan.perez@example.com - Admin
2. María García - maria.garcia@example.com - Usuario
3. Carlos López - carlos.lopez@example.com - Usuario
4. Ana Martínez - ana.martinez@example.com - Admin

## 📊 Base de Datos

### Tabla: `admin_users` (Autenticación)
```sql
- id (INT, PK, AUTO_INCREMENT)
- username (VARCHAR(50), UNIQUE)
- password (VARCHAR(255), HASHED)
- created_at (TIMESTAMP)
```

### Tabla: `users` (CRUD)
```sql
- id (INT, PK, AUTO_INCREMENT)
- nombre (VARCHAR(100))
- email (VARCHAR(100), UNIQUE)
- rol (ENUM: 'admin', 'usuario')
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

## 🎯 Funcionalidades Implementadas

### 1. Sistema de Login ✅
- Pantalla de inicio de sesión con campos de usuario y contraseña
- Validación contra base de datos MySQL
- Contraseñas hasheadas con Werkzeug
- Redirección al dashboard si login exitoso
- Mensajes de error descriptivos
- Protección de rutas con decorador `@login_required`

### 2. CRUD Completo ✅

#### Crear Usuario (2 pts)
- Formulario con campos: nombre, email, rol
- Validación de campos obligatorios
- Verificación de email único
- Mensajes de confirmación

#### Leer Usuarios (2 pts)
- Tabla con todos los usuarios
- Columnas: ID, Nombre, Email, Rol, Fecha de Creación
- Badges de colores para roles
- Diseño responsivo

#### Actualizar Usuario (3 pts)
- Formulario precargado con datos actuales
- Validación de campos
- Actualización en tiempo real
- Confirmación de cambios

#### Eliminar Usuario (3 pts)
- Botón de eliminar por usuario
- Modal de confirmación
- Mensaje de advertencia
- Confirmación de eliminación exitosa

## 🎨 Capturas de Pantalla

### Pantalla de Login
![Login](docs/screenshots/login.png)

### Dashboard con Lista de Usuarios
![Dashboard](docs/screenshots/dashboard.png)

### Formulario de Creación
![Create User](docs/screenshots/create.png)

### Formulario de Edición
![Edit User](docs/screenshots/edit.png)

### Modal de Confirmación de Eliminación
![Delete Confirmation](docs/screenshots/delete.png)

## 🎥 Video Demostrativo

📹 **[Ver Video Demostrativo (5 min)](ENLACE_A_YOUTUBE_O_DRIVE)**

El video muestra:
1. Login exitoso con credenciales correctas
2. Login fallido con credenciales incorrectas
3. Listado de usuarios (READ)
4. Creación de nuevo usuario (CREATE)
5. Edición de usuario existente (UPDATE)
6. Eliminación de usuario con confirmación (DELETE)

## 🔧 Solución de Problemas

### Error de conexión a MySQL
```bash
# Verificar que MySQL está corriendo
docker-compose ps

# Ver logs de MySQL
docker-compose logs db
```

### Puerto 5000 ya en uso
```bash
# Cambiar el puerto en docker-compose.yml
ports:
  - "5001:5000"  # Usar 5001 en lugar de 5000
```

### Error de permisos en MySQL
```bash
# Recrear los contenedores
docker-compose down -v
docker-compose up --build
```

## 📝 Notas Adicionales

- La contraseña del usuario admin está hasheada con `scrypt`
- Las sesiones expiran al cerrar el navegador
- Los emails deben ser únicos en la base de datos
- Los roles disponibles son: `admin` y `usuario`

## 👨‍💻 Autor

Desarrollado como parte del Laboratorio Adicional de Computación Cognitiva.

## 📄 Licencia

Este proyecto es de uso académico para el curso de Computación Cognitiva.

---

**Nota**: Este proyecto cumple con todos los requisitos técnicos especificados en la guía de laboratorio (20 puntos totales: 10 pts Login + 10 pts CRUD).
