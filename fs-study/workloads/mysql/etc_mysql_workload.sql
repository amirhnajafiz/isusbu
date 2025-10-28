USE testdb;

-- Transaction
START TRANSACTION;

-- Inserts
INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');
INSERT INTO users (name, email) VALUES ('Bob', 'bob@example.com');

INSERT INTO posts (user_id, title, content, tags)
VALUES (1, 'Intro to MySQL', 'This post tests MySQL basics', JSON_ARRAY('intro','mysql'));
INSERT INTO posts (user_id, title, content, tags)
VALUES (2, 'Advanced MySQL', 'Testing triggers, views, and JSON', JSON_OBJECT('topic','advanced','db','mysql'));

COMMIT;

-- Updates
UPDATE posts SET title = CONCAT(title, ' Updated') WHERE id = 1;

-- JSON functions
SELECT JSON_EXTRACT(tags, '$[0]') AS first_tag FROM posts WHERE id = 1;

-- View query
SELECT * FROM user_post_count;

-- Full-text search
SELECT * FROM posts WHERE MATCH(title, content) AGAINST ('mysql' IN NATURAL LANGUAGE MODE);

-- Delete + cascade test
DELETE FROM users WHERE name='Bob';

-- Show foreign key cascade worked
SELECT * FROM posts;

-- Performance check
SHOW TABLE STATUS;
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
