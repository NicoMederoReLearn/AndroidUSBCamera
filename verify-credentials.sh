#!/bin/bash

# Script to verify GitHub credentials for publishing
set -e

echo "🔍 GitHub Credentials Verification"
echo "=================================="
echo ""

# Check if local.properties exists
if [ ! -f "local.properties" ]; then
    echo "❌ local.properties not found!"
    exit 1
fi

# Read credentials
GITHUB_ACTOR=$(grep "github.actor=" local.properties | cut -d'=' -f2 | tr -d '\r\n ')
GITHUB_TOKEN=$(grep "github.token=" local.properties | cut -d'=' -f2 | tr -d '\r\n ')

if [ -z "$GITHUB_ACTOR" ]; then
    echo "❌ github.actor is not set in local.properties"
    exit 1
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ github.token is not set in local.properties"
    exit 1
fi

echo "✅ Found credentials in local.properties"
echo "   Username: $GITHUB_ACTOR"
echo "   Token: ${GITHUB_TOKEN:0:10}... (${#GITHUB_TOKEN} characters)"
echo ""

# Test authentication with GitHub API
echo "🔐 Testing authentication with GitHub API..."
RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user)

# Check if authenticated
LOGIN=$(echo $RESPONSE | grep -o '"login":"[^"]*"' | cut -d'"' -f4)

if [ -z "$LOGIN" ]; then
    echo "❌ Authentication FAILED!"
    echo ""
    echo "Possible issues:"
    echo "1. Token is invalid or expired"
    echo "2. Token doesn't have the required scopes"
    echo ""
    echo "Response from GitHub:"
    echo $RESPONSE | python3 -m json.tool 2>/dev/null || echo $RESPONSE
    echo ""
    echo "👉 Create a new token at: https://github.com/settings/tokens"
    echo "   Required scopes: repo, write:packages, read:packages"
    exit 1
fi

echo "✅ Authentication successful!"
echo "   Authenticated as: $LOGIN"
echo ""

# Check if username matches
if [ "$LOGIN" != "$GITHUB_ACTOR" ]; then
    echo "⚠️  WARNING: Username mismatch!"
    echo "   local.properties says: $GITHUB_ACTOR"
    echo "   GitHub API says: $LOGIN"
    echo ""
    echo "👉 Update local.properties with the correct username:"
    echo "   github.actor=$LOGIN"
    exit 1
fi

# Check token scopes
echo "🔍 Checking token scopes..."
SCOPES=$(curl -s -I -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep -i "x-oauth-scopes:" | cut -d' ' -f2- | tr -d '\r\n')

echo "   Token scopes: $SCOPES"
echo ""

# Check for required scopes
HAS_REPO=false
HAS_WRITE_PACKAGES=false
HAS_READ_PACKAGES=false

if echo "$SCOPES" | grep -q "repo"; then
    HAS_REPO=true
fi

if echo "$SCOPES" | grep -q "write:packages"; then
    HAS_WRITE_PACKAGES=true
fi

if echo "$SCOPES" | grep -q "read:packages"; then
    HAS_READ_PACKAGES=true
fi

echo "Required scopes check:"
if [ "$HAS_REPO" = true ]; then
    echo "   ✅ repo"
else
    echo "   ❌ repo (MISSING)"
fi

if [ "$HAS_WRITE_PACKAGES" = true ]; then
    echo "   ✅ write:packages"
else
    echo "   ❌ write:packages (MISSING)"
fi

if [ "$HAS_READ_PACKAGES" = true ]; then
    echo "   ✅ read:packages"
else
    echo "   ❌ read:packages (MISSING)"
fi

echo ""

if [ "$HAS_REPO" = true ] && [ "$HAS_WRITE_PACKAGES" = true ] && [ "$HAS_READ_PACKAGES" = true ]; then
    echo "🎉 All required scopes are present!"
    echo ""
    echo "✅ Your credentials are valid and ready for publishing!"
    echo ""
    echo "You can now run:"
    echo "   ./gradlew publish"
else
    echo "❌ Some required scopes are missing!"
    echo ""
    echo "👉 Create a new token with all required scopes:"
    echo "   1. Go to: https://github.com/settings/tokens"
    echo "   2. Click 'Generate new token (classic)'"
    echo "   3. Select these scopes:"
    echo "      ☑ repo"
    echo "      ☑ write:packages"
    echo "      ☑ read:packages"
    echo "   4. Generate token and copy it"
    echo "   5. Update local.properties:"
    echo "      github.token=NEW_TOKEN_HERE"
    exit 1
fi

