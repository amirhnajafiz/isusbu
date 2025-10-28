#!/usr/bin/env bash

# check to see if apache-benchmark is installed
if ! command -v mysql &> /dev/null
then
    echo "mysql could not be found, please install it to run this workload."
    exit 1
fi

for i in {1..1000}; do
  sudo mysql -e "USE testdb; INSERT INTO users (name, email) VALUES ('User$i', 'user$i@example.com');"
  sudo mysql -e "USE testdb; INSERT INTO posts (user_id, title, content, tags)
  VALUES ($((i%2+1)), 'Post$i', 'Load testing MySQL', JSON_ARRAY('test','load'));"
done

echo "MySQL workload completed."
