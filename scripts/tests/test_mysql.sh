#!/bin/bash
# Tests that your MySQL server is up and running for Wordpress

MYSQL_NAME=${MYSQL_NAME:-wordpress}
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}

# Add validation for required environment variables
if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "ERROR: MYSQL_USER and MYSQL_PASSWORD must be set"
    exit 1
fi

# Add logging function
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Test 1: Check if MySQL is up and running
netstat -tlnp | grep 3306
if [ $? -eq 0 ]; then
    log_message "Test 21: MySQL is up and running"
else
    log_message "ERROR: Test 21: MySQL is NOT up and running"
    exit 1
fi

# Test 2: Check if the WordPress database exists
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SHOW DATABASES LIKE '${MYSQL_NAME}';"
if [ $? -eq 0 ]; then
  log_message "Test 1: WordPress database exists"
else
  log_message "ERROR: Test 1: WordPress database does NOT exist"
  exit 1
fi

# Test 2: Check if the WordPress user has the correct privileges
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SHOW GRANTS FOR '${MYSQL_USER}'@'localhost';"
if [ $? -eq 0 ]; then
  log_message "Test 2: WordPress user has correct privileges"
else
  log_message "ERROR: Test 2: WordPress user does NOT have correct privileges"
  exit 1
fi

# Test 3: Check if the WordPress tables are created
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SHOW TABLES IN ${MYSQL_NAME};"
if [ $? -eq 0 ]; then
  log_message "Test 3: WordPress tables are created"
else
  log_message "ERROR: Test 3: WordPress tables are NOT created"
  exit 1
fi
