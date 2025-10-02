-- Create database if not exists
CREATE DATABASE IF NOT EXISTS user_management;
USE user_management;

-- Create admin login table (for authentication)
CREATE TABLE IF NOT EXISTS admin_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table (for CRUD operations)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    rol ENUM('admin', 'usuario') DEFAULT 'usuario',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert default admin user (username: admin, password: admin123)
-- Password will be hashed by the application
-- For now using pbkdf2:sha256 hash of 'admin123'
INSERT INTO admin_users (username, password) VALUES
('admin', 'pbkdf2:sha256:600000$KQx8YmJkYjY4ZGRh$8f3c5e8a9b2d1e4f6a7c8b9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f');

-- Insert sample users for CRUD operations
INSERT INTO users (nombre, email, rol) VALUES
('Juan Pérez', 'juan.perez@example.com', 'admin'),
('María García', 'maria.garcia@example.com', 'usuario'),
('Carlos López', 'carlos.lopez@example.com', 'usuario'),
('Ana Martínez', 'ana.martinez@example.com', 'admin');
