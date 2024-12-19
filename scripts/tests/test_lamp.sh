#!/bin/bash

# Add logging function
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Check if all required software is installed
command -v wp >/dev/null 2>&1 || { log_message "WP-CLI not installed"; exit 1; }
command -v mysql >/dev/null 2>&1 || { log_message "MySQL not installed"; exit 1; }
command -v certbot >/dev/null 2>&1 || { log_message "Certbot not installed"; exit 1; }

# Tests that your LAMP server is up and running
netstat -tlnp | grep 80
if [ $? -eq 0 ]; then
    log_message "Test 1: Apache is up and running"
else
    log_message "ERROR: Test 1: Apache is NOT up and running"
    exit 1
fi

netstat -tlnp | grep 8080
if [ $? -eq 0 ]; then
    log_message "Test 2: Varnish is up and running"
else
    log_message "ERROR: Test 2: Varnish is NOT up and running"
    exit 1
fi

php scripts/tests/test_php.php
if [ $? -eq 0 ]; then
  log_message "Test 3: PHP installation test passed!"
else
  log_message "ERROR: Test 3: PHP installation test FAILED!"
  exit 1
fi

sudo ufw status
if [ $? -eq 0 ]; then
    log_message "Test 4: Firewall is up and running"
else
    log_message "ERROR: Test 4: Firewall is NOT up and running"
    exit 1
fi

log_message "All tests passed"
