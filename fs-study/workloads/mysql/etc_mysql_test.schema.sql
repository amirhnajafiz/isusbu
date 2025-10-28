CREATE DATABASE testdb;
USE testdb;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Posts table with foreign key
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    title VARCHAR(200),
    content TEXT,
    tags JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Indexes
CREATE INDEX idx_user_id ON posts(user_id);
CREATE FULLTEXT INDEX idx_title_content ON posts(title, content);

-- View
CREATE VIEW user_post_count AS
SELECT u.name, COUNT(p.id) AS post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id;

-- Trigger
DELIMITER //
CREATE TRIGGER before_post_insert
BEFORE INSERT ON posts
FOR EACH ROW
BEGIN
    IF NEW.title IS NULL OR NEW.title = '' THEN
        SET NEW.title = 'Untitled';
    END IF;
END;
//
DELIMITER ;
