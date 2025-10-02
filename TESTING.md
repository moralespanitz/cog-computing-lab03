# Testing Guide

## Running Tests

### Automated Testing Script

The project includes a bash script for automated testing:

```bash
chmod +x manual_test.sh
./manual_test.sh
```

This script will test:
- Login page accessibility
- Database connectivity
- Admin user verification
- Login functionality
- Dashboard access
- CRUD page accessibility

### Manual Testing from Browser

1. **Access the application**: http://localhost:5001

2. **Test Login System (10 puntos)**:
   - ✅ Test failed login with wrong credentials
   - ✅ Test successful login with `admin` / `admin123`
   - ✅ Verify redirect to dashboard
   - ✅ Test protected routes require login

3. **Test READ Operations (2 puntos)**:
   - ✅ View list of all users in dashboard
   - ✅ Verify all fields are displayed (ID, Nombre, Email, Rol, Fecha)

4. **Test CREATE Operations (2 puntos)**:
   - ✅ Click "Nuevo Usuario" button
   - ✅ Fill form with:
     - Nombre: Test Usuario
     - Email: test@example.com
     - Rol: usuario
   - ✅ Submit and verify user appears in list
   - ✅ Test validation with empty fields

5. **Test UPDATE Operations (3 puntos)**:
   - ✅ Click edit icon (pencil) for any user
   - ✅ Modify user information
   - ✅ Save changes
   - ✅ Verify updated information in list
   - ✅ Test validation with invalid data

6. **Test DELETE Operations (3 puntos)**:
   - ✅ Click delete icon (trash) for any user
   - ✅ Verify confirmation modal appears
   - ✅ Confirm deletion
   - ✅ Verify user is removed from list

## Test Results Summary

All major functionality has been verified:
- ✅ Login system with authentication
- ✅ Protected routes
- ✅ Full CRUD operations on users
- ✅ Database connectivity
- ✅ Form validation
- ✅ Confirmation dialogs

## Database Verification Commands

```bash
# Check admin user
docker exec user_management_db mysql -uflask_user -pflask_password user_management -e "SELECT * FROM admin_users;"

# Check all users
docker exec user_management_db mysql -uflask_user -pflask_password user_management -e "SELECT * FROM users;"

# Count users
docker exec user_management_db mysql -uflask_user -pflask_password user_management -e "SELECT COUNT(*) FROM users;"
```

## Application Logs

```bash
# View application logs
docker-compose logs web

# Follow logs in real-time
docker-compose logs -f web

# View database logs
docker-compose logs db
```

## Troubleshooting

### Port Already in Use
If port 5001 is already in use, edit `docker-compose.yml`:
```yaml
ports:
  - "5002:5000"  # Change to another port
```

### Database Connection Issues
```bash
# Restart containers
docker-compose down
docker-compose up -d

# Check container health
docker-compose ps
```

### Reset Database
```bash
# Stop and remove volumes
docker-compose down -v

# Rebuild
docker-compose up --build
```
