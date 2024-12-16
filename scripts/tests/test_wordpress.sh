#!/bin/bash
# Tests your Wordpress site. Prompts for DOMAIN variable if not defined or passed as first argument
DOMAIN=${DOMAIN}

if [ -z "$DOMAIN" ]; then
    if [ -z "$1" ]; then
        read -s -p "Enter domain name: " DOMAIN
    else
        DOMAIN=$1
    fi
fi

# Test 1: Check if the WordPress site is up and running
curl -s -o /dev/null -w "%{http_code}" http://${DOMAIN}
if [ $? -eq 200 ]; then
  echo "Test 1: WordPress site is up and running"
else
  echo "Test 1: WordPress site is not up and running"
  exit 1
fi

# Test 2: Check if the WordPress site is configured correctly
curl -s -o /dev/null -w "%{http_code}" http://${DOMAIN}/wp-admin
if [ $? -eq 200 ]; then
  echo "Test 2: WordPress site is configured correctly"
else
  echo "Test 2: WordPress site is not configured correctly"
  exit 1
fi

# Test 3: Check if the WordPress site is accessible via HTTPS
curl -s -o /dev/null -w "%{http_code}" https://${DOMAIN}
if [ $? -eq 200 ]; then
  echo "Test 3: WordPress site is accessible via HTTPS"
else
  echo "Test 3: WordPress site is not accessible via HTTPS"
  exit 1
fi
