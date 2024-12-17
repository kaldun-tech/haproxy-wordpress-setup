#!/bin/bash

# Tests that your LAMP server is up and running
netstat -tlnp | grep 80
if [ $? -eq 0 ]; then
    echo "Test 1: Apache is up and running"
else
    echo "Test 1: Apache is NOT up and running"
    exit 1
fi

netstat -tlnp | grep 3306
if [ $? -eq 0 ]; then
    echo "Test 2: MySQL is up and running"
else
    echo "Test 2: MySQL is NOT up and running"
    exit 1
fi

netstat -tlnp | grep 8080
if [ $? -eq 0 ]; then
    echo "Test 4: Varnish is up and running"
else
    echo "Test 4: Varnish is NOT up and running"
    exit 1
fi

php scripts/tests/test_php.php
if [ $? -eq 0 ]; then
  echo "Test 5: PHP installation test passed!"
else
  echo "Test 5: PHP installation test failed!"
  exit 1
fi

sudo ufw status
if [ $? -eq 0 ]; then
    echo "Test 6: Firewall is up and running"
else
    echo "Test 6: Firewall is NOT up and running"
    exit 1
fi

echo "All tests passed"
