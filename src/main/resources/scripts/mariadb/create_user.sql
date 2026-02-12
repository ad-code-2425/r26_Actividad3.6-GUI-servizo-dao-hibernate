CREATE USER 'user_instituto'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON instituto.* TO 'user_instituto'@'localhost';
FLUSH PRIVILEGES;