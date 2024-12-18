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

# Add logging function
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Use it in tests
log_message "Starting WordPress tests for domain: $DOMAIN"
curl -s -o /dev/null -w "%{http_code}" http://${DOMAIN}
if [ $? -eq 200 ]; then
    log_message "Test 1: WordPress site is up and running"
else
    log_message "ERROR: Test 1: WordPress site is NOT up and running"
    exit 1
fi

# Test 2: Check if the WordPress site is configured correctly
curl -s -o /dev/null -w "%{http_code}" http://${DOMAIN}/wp-admin
if [ $? -eq 200 ]; then
  log_message "Test 2: WordPress site is configured correctly"
else
  log_message "ERROR: Test 2: WordPress site is NOT configured correctly"
  exit 1
fi

# Test 3: Check if the WordPress site is accessible via HTTPS
curl -s -o /dev/null -w "%{http_code}" https://${DOMAIN}
if [ $? -eq 200 ]; then
  log_message "Test 3: WordPress site is accessible via HTTPS"
else
  log_message "ERROR: Test 3: WordPress site is NOT accessible via HTTPS"
  exit 1
fi
