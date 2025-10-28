# Installation

Installation commands on Ubuntu:

```bash
# copy the schema and workload files
cp etc_mysql_test.schema.sql /etc/mysql/test_schema.sql
cp etc_mysql_workload.sql /etc/mysql/workload.sql

# apply the files
sudo mysql < /etc/mysql/test_schema.sql
sudo mysql < /etc/mysql/workload.sql
```
