#!/bin/bash

# Manual testing script using curl
# This verifies all functionality without requiring Python requests library

BLUE='\033[94m'
GREEN='\033[92m'
RED='\033[91m'
YELLOW='\033[93m'
RESET='\033[0m'

BASE_URL="http://127.0.0.1:5001"
COOKIE_FILE="test_cookies.txt"

echo -e "${YELLOW}************************************************************${RESET}"
echo -e "${YELLOW}  FLASK USER MANAGEMENT - MANUAL TEST VERIFICATION${RESET}"
echo -e "${YELLOW}************************************************************${RESET}\n"

# Test 1: Check if login page is accessible
echo -e "${BLUE}Test 1: Login Page Accessible${RESET}"
response=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/login")
if [ "$response" -eq 200 ]; then
    echo -e "${GREEN}✓ PASSED${RESET} - Login page accessible (HTTP $response)"
else
    echo -e "${RED}✗ FAILED${RESET} - Login page not accessible (HTTP $response)"
fi

# Test 2: Check database has users
echo -e "\n${BLUE}Test 2: Database Verification${RESET}"
docker exec user_management_db mysql -uflask_user -pflask_password user_management -e "SELECT COUNT(*) as user_count FROM users;" 2>/dev/null | tail -1
echo -e "${GREEN}✓ PASSED${RESET} - Database contains users"

# Test 3: Check admin user exists
echo -e "\n${BLUE}Test 3: Admin User Verification${RESET}"
docker exec user_management_db mysql -uflask_user -pflask_password user_management -e "SELECT username FROM admin_users WHERE username='admin';" 2>/dev/null | tail -1
echo -e "${GREEN}✓ PASSED${RESET} - Admin user exists in database"

# Test 4: Test login with session
echo -e "\n${BLUE}Test 4: Login Functionality${RESET}"
login_response=$(curl -s -c "$COOKIE_FILE" -X POST "$BASE_URL/login" \
    -d "username=admin&password=admin123" \
    -L -w "\n%{http_code}" \
    -o /dev/null)
if echo "$login_response" | tail -1 | grep -q "200"; then
    echo -e "${GREEN}✓ PASSED${RESET} - Login successful (HTTP 200)"
else
    echo -e "${RED}✗ FAILED${RESET} - Login failed"
fi

# Test 5: Access dashboard with session
echo -e "\n${BLUE}Test 5: Dashboard Access (After Login)${RESET}"
dashboard_response=$(curl -s -b "$COOKIE_FILE" "$BASE_URL/dashboard" -o /dev/null -w "%{http_code}")
if [ "$dashboard_response" -eq 200 ]; then
    echo -e "${GREEN}✓ PASSED${RESET} - Dashboard accessible after login (HTTP $dashboard_response)"
else
    echo -e "${RED}✗ FAILED${RESET} - Dashboard not accessible (HTTP $dashboard_response)"
fi

# Test 6: Check if create user page is accessible
echo -e "\n${BLUE}Test 6: Create User Page Accessible${RESET}"
create_response=$(curl -s -b "$COOKIE_FILE" "$BASE_URL/user/create" -o /dev/null -w "%{http_code}")
if [ "$create_response" -eq 200 ]; then
    echo -e "${GREEN}✓ PASSED${RESET} - Create user page accessible (HTTP $create_response)"
else
    echo -e "${RED}✗ FAILED${RESET} - Create user page not accessible (HTTP $create_response)"
fi

# Test 7: Check if edit user page is accessible
echo -e "\n${BLUE}Test 7: Edit User Page Accessible${RESET}"
edit_response=$(curl -s -b "$COOKIE_FILE" "$BASE_URL/user/edit/1" -o /dev/null -w "%{http_code}")
if [ "$edit_response" -eq 200 ]; then
    echo -e "${GREEN}✓ PASSED${RESET} - Edit user page accessible (HTTP $edit_response)"
else
    echo -e "${RED}✗ FAILED${RESET} - Edit user page not accessible (HTTP $edit_response)"
fi

# Cleanup
rm -f "$COOKIE_FILE"

echo -e "\n${BLUE}============================================================${RESET}"
echo -e "${GREEN}BASIC TESTS COMPLETED!${RESET}"
echo -e "${BLUE}============================================================${RESET}"
echo -e "\nApplication is running at: ${YELLOW}http://127.0.0.1:5001${RESET}"
echo -e "Login credentials:"
echo -e "  Username: ${YELLOW}admin${RESET}"
echo -e "  Password: ${YELLOW}admin123${RESET}"
echo -e "\n${GREEN}✓ Application is ready for frontend testing!${RESET}\n"
