CREATE DATABASE IF NOT EXISTS wordpress;
DROP USER IF EXISTS 'wordpressuser'@'%';
CREATE USER 'wordpressuser'@'%' IDENTIFIED BY 'mypassword';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'%';
FLUSH PRIVILEGES;
