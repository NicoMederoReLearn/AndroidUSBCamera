# 401 Unauthorized Error - Troubleshooting Guide

## The Issue
You're getting a 401 Unauthorized error when trying to publish to GitHub Packages. This means GitHub is rejecting your credentials.

## Common Causes & Solutions

### 1. Token Permissions (Most Likely)
Your GitHub token might not have the required scopes.

**Required Scopes:**
- ✅ `write:packages` - To upload packages
- ✅ `read:packages` - To read package metadata
- ✅ `repo` - To access repository information

**How to Fix:**
1. Go to: https://github.com/settings/tokens
2. Find your token or create a new one
3. Make sure these scopes are checked:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `write:packages` (Upload packages to GitHub Package Registry)
   - ✅ `read:packages` (Download packages from GitHub Package Registry)
4. If you created a new token, copy it
5. Update your `local.properties`:
   ```properties
   github.actor=NicoMederoReLearn
   github.token=ghp_NEW_TOKEN_HERE
   ```

### 2. Token Expired
GitHub tokens can expire. Create a new token with no expiration or a longer expiration date.

### 3. Wrong Username
Make sure the username matches exactly (case-sensitive):
- ✅ Correct: `NicoMederoReLearn`
- ❌ Wrong: `nicomederelearn` or `NicoMedero`

### 4. Token Has Special Characters
If your token has special characters, make sure there are no extra spaces or line breaks in `local.properties`.

## Quick Test - Verify Your Credentials

Run this script to check if your credentials are valid:

```bash
./verify-credentials.sh
```

This will:
- ✅ Check if credentials exist in local.properties
- ✅ Test authentication with GitHub
- ✅ Verify the token has all required scopes
- ✅ Show you exactly what's wrong if there's an issue

## Step-by-Step Fix

### Option 1: Create New Token (Recommended)

1. **Go to GitHub Settings:**
   https://github.com/settings/tokens

2. **Click "Generate new token (classic)"**

3. **Set up the token:**
   - Note: `AndroidUSBCamera Publishing`
   - Expiration: Choose "No expiration" or a long duration
   - Select scopes:
     - ☑ **repo** (Full control of private repositories)
     - ☑ **write:packages** (Upload packages)
     - ☑ **read:packages** (Download packages)

4. **Generate and copy the token**
   - It will look like: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   - ⚠️ Save it now - you won't see it again!

5. **Update local.properties:**
   ```bash
   # Edit the file
   nano local.properties
   
   # Or use echo (replace YOUR_NEW_TOKEN)
   echo "github.actor=NicoMederoReLearn" > local.properties
   echo "github.token=ghp_YOUR_NEW_TOKEN_HERE" >> local.properties
   ```

6. **Try publishing again:**
   ```bash
   ./gradlew publish
   ```

### Option 2: Check Existing Token

If you want to keep your existing token:

1. **Go to:** https://github.com/settings/tokens
2. **Find your token** in the list
3. **Click on it** to see its scopes
4. **Make sure it has:**
   - ✅ repo
   - ✅ write:packages
   - ✅ read:packages
5. **If any scope is missing:**
   - You need to create a new token (tokens can't be edited after creation)

## Common Mistakes to Avoid

### ❌ Don't do this:
```properties
github.actor = NicoMederoReLearn    # Spaces around =
github.token = ghp_xxx              # Spaces around =
```

### ✅ Do this:
```properties
github.actor=NicoMederoReLearn
github.token=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### ❌ Don't do this:
```properties
# Token on multiple lines
github.token=ghp_xxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxx
```

### ✅ Do this:
```properties
# Token on one line
github.token=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## Verify Repository Access

Your token needs access to the `NicoMederoReLearn/AndroidUSBCamera` repository:

1. **Check repository visibility:**
   - Go to: https://github.com/NicoMederoReLearn/AndroidUSBCamera/settings
   - Make sure you have admin or write access

2. **If it's a private repo:**
   - Your token MUST have the `repo` scope

3. **If it's a public repo:**
   - Your token still needs `write:packages` and `read:packages`

## Test Publishing to Local Maven First

Before publishing to GitHub, test locally:

```bash
# Publish to local Maven repository (~/.m2/repository)
./gradlew publishToMavenLocal

# If this works, your build configuration is correct
# The issue is definitely with GitHub credentials
```

## Still Getting 401?

If you still get 401 after creating a new token with correct scopes:

1. **Double-check the username:**
   ```bash
   # Should output: NicoMederoReLearn
   grep "github.actor" local.properties
   ```

2. **Check for hidden characters:**
   ```bash
   # View the file with hidden characters
   cat -A local.properties
   ```
   Look for `^M` or extra `$` at line ends.

3. **Recreate local.properties from scratch:**
   ```bash
   rm local.properties
   echo "github.actor=NicoMederoReLearn" > local.properties
   echo "github.token=YOUR_TOKEN" >> local.properties
   ```

4. **Try with a different repository URL format:**
   This is unlikely, but you can try publishing to Maven Central or another registry to isolate the issue.

## Need More Help?

Run the verification script with debugging:
```bash
bash -x ./verify-credentials.sh
```

This will show you exactly what's happening at each step.

---

## Summary

**Most likely cause:** Your token doesn't have `write:packages` scope.

**Solution:** Create a new token with all three scopes (repo, write:packages, read:packages) and update local.properties.

**Test command:**
```bash
./verify-credentials.sh
```

**Then publish:**
```bash
./gradlew publish
```


