#!/bin/bash

LOGIN_ENDPOINT="http://dhoody.aws.chickenkiller.com:5000/login"

# Test successful login
echo "Checking successful login..."
success_response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -F "username=user1" -F "password=password1"  ${LOGIN_ENDPOINT})
if [ "$success_response" -eq 302 ]; then
    echo "Successful login test passed!"
else
    echo "$success_response"
    echo "Successful login test failed!"
    exit 1
fi

# Test login with invalid credentials
echo "Checking login with invalid credentials..."
invalid_response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -F "username=invalid_username" -F "password=invalid_password"  ${LOGIN_ENDPOINT})
if [ "$invalid_response" -eq 401 ]; then
    echo "Invalid credentials test passed!"
else
    echo "Invalid credentials test failed!"
    exit 1
fi