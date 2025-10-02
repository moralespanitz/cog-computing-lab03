"""Script to create admin user with proper password hash"""
from werkzeug.security import generate_password_hash

# Generate password hash for 'admin123'
password_hash = generate_password_hash('admin123')
print(f"Password hash for 'admin123':")
print(password_hash)
print("\nUpdate init.sql with this hash")
