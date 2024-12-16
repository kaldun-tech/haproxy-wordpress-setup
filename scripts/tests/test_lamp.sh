#!/bin/bash

# Tests that your LAMP server is up and running
netstat -tlnp | grep 80
if [ $? -eq 0 ]; then
    echo "Test 1: Apache is up and running"
else
    echo "Test 1: Apache is not up and running"
    exit 1
fi

netstat -tlnp | grep 3306
if [ $? -eq 0 ]; then
    echo "Test 2: MySQL is up and running"
else
    echo "Test 2: MySQL is not up and running"
    exit 1
fi

netstat -tlnp | grep 8080
if [ $? -eq 0 ]; then
    echo "Test 4: Varnish is up and running"
else
    echo "Test 4: Varnish is not up and running"
    exit 1
fi

ufw status
if [ $? -eq 0 ]; then
    echo "Test 5: Firewall is up and running"
else
    echo "Test 5: Firewall is not up and running"
    exit 1
fi

# Test PHP installation
echo "Testing PHP installation..."
php scripts/tests/test_php.php
if [ $? -eq 0 ]; then
  echo "PHP installation test passed!"
else
  echo "PHP installation test failed!"
  exit 1
fi

echo "All tests passed"
