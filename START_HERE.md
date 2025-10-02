# 🚀 START HERE - Quick Start Guide

## ✅ Application Status: RUNNING

Your Flask User Management System is **DEPLOYED AND READY TO TEST**!

---

## 🌐 Access the Application

**Open your browser and go to:**
```
http://localhost:5001
```

### 🔑 Login Credentials
```
Username: admin
Password: admin123
```

---

## 🎯 What to Test (Follow This Order)

### 1. Login System (10 puntos)
- [ ] Try logging in with **wrong credentials** → Should show error
- [ ] Login with **admin/admin123** → Should redirect to dashboard
- [ ] Try accessing `/dashboard` without login → Should redirect to login

### 2. READ - View Users (2 puntos)
- [ ] View the list of users in dashboard
- [ ] Verify all fields are shown: ID, Nombre, Email, Rol, Fecha

### 3. CREATE - New User (2 puntos)
- [ ] Click "Nuevo Usuario" button
- [ ] Fill form:
  - Nombre: `Test Usuario`
  - Email: `test@ejemplo.com`
  - Rol: `usuario`
- [ ] Submit and verify user appears in list
- [ ] Try submitting empty form → Should show validation error

### 4. UPDATE - Edit User (3 puntos)
- [ ] Click the **pencil icon** (✏️) next to any user
- [ ] Change the name or email
- [ ] Click "Guardar Cambios"
- [ ] Verify changes appear in the list

### 5. DELETE - Remove User (3 puntos)
- [ ] Click the **trash icon** (🗑️) next to a user
- [ ] Confirmation modal should appear
- [ ] Click "Eliminar"
- [ ] Verify user is removed from list

### 6. Logout
- [ ] Click "Cerrar Sesión" in navbar
- [ ] Should redirect to login page

---

## 🎬 Recording Your Video (5 min max)

Record your screen showing:
1. Failed login attempt
2. Successful login
3. View users (READ)
4. Create new user (CREATE)
5. Edit existing user (UPDATE)
6. Delete a user (DELETE)

**Tips**:
- Narrate what you're doing
- Keep it under 5 minutes
- Show each operation clearly
- Upload to YouTube or Google Drive

---

## 📊 System Information

### Containers Running
```bash
docker-compose ps
```

Expected output:
- ✅ `user_management_app` - Flask application (port 5001)
- ✅ `user_management_db` - MySQL database (port 3306)

### Database Contents
```bash
# View all users
docker exec user_management_db mysql -uflask_user -pflask_password user_management -e "SELECT * FROM users;"

# Expected: 4 sample users
# 1. Juan Pérez (admin)
# 2. María García (usuario)
# 3. Carlos López (usuario)
# 4. Ana Martínez (admin)
```

---

## 🛠️ Useful Commands

### Stop the Application
```bash
docker-compose down
```

### Restart the Application
```bash
docker-compose restart
```

### View Logs
```bash
docker-compose logs -f web
```

### Reset Database (if needed)
```bash
docker-compose down -v
docker-compose up -d
```

---

## 📁 Important Files

- `README.md` - Complete documentation
- `DEPLOYMENT_SUMMARY.md` - Detailed deployment info
- `TESTING.md` - Testing guide
- `manual_test.sh` - Automated tests
- `app.py` - Main Flask application
- `database/init.sql` - Database schema

---

## ✅ Checklist for Submission

- [ ] Test all CRUD operations manually
- [ ] Record 5-minute demonstration video
- [ ] Upload code to GitHub repository
- [ ] Upload video to YouTube/Google Drive
- [ ] Submit links to instructor

---

## 🆘 Troubleshooting

### Application not accessible?
```bash
# Check if containers are running
docker-compose ps

# Restart if needed
docker-compose restart
```

### Port 5001 in use?
Edit `docker-compose.yml` and change:
```yaml
ports:
  - "5002:5000"  # Use different port
```

### Database issues?
```bash
# Reset everything
docker-compose down -v
docker-compose up --build
```

---

## 🎉 You're Ready!

**Open http://localhost:5001 and start testing!**

---

*For detailed information, see README.md and DEPLOYMENT_SUMMARY.md*
