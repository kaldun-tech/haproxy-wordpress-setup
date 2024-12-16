#!/bin/bash
# Tests that your MySQL server is up and running for Wordpress

MYSQL_NAME=${MYSQL_NAME:-wordpress}
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}

# Test 1: Check if the WordPress database exists
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SHOW DATABASES LIKE '${MYSQL_NAME}';"
if [ $? -eq 0 ]; then
  echo "Test 1: WordPress database exists"
else
  echo "Test 1: WordPress database does not exist"
  exit 1
fi

# Test 2: Check if the WordPress user has the correct privileges
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SHOW GRANTS FOR '${MYSQL_USER}'@'localhost';"
if [ $? -eq 0 ]; then
  echo "Test 2: WordPress user has correct privileges"
else
  echo "Test 2: WordPress user does not have correct privileges"
  exit 1
fi

# Test 3: Check if the WordPress tables are created
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SHOW TABLES IN ${MYSQL_NAME};"
if [ $? -eq 0 ]; then
  echo "Test 3: WordPress tables are created"
else
  echo "Test 3: WordPress tables are not created"
  exit 1
fi
