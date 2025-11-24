# Why Your Existing Credentials Aren't Authorized

Based on the 401 error you're getting, here are the **most likely reasons** your existing token isn't working for this repository:

## 🔍 Primary Reasons (In Order of Likelihood)

### 1. ⚠️ Missing `write:packages` Scope
**This is the #1 reason for 401 errors when publishing to GitHub Packages**

GitHub Packages requires a **specific scope** that's separate from repository access:
- ❌ Having `repo` scope is NOT enough
- ✅ You MUST have `write:packages` scope explicitly selected

**Why this happens:**
- Many users create tokens with `repo` scope only (for git operations)
- They assume `repo` covers everything, but **it doesn't cover packages**
- GitHub Packages requires separate `write:packages` and `read:packages` scopes

### 2. 🕐 Token Expiration
Check when you created your token:
- Tokens created with 7, 30, 60, or 90-day expiration may have expired
- GitHub tokens created before a certain date may have been automatically revoked
- Fine-grained tokens expire by default

### 3. 🔒 Token Type: Classic vs Fine-grained
**Important:** GitHub has two types of tokens:

#### Classic Tokens (Recommended for Packages)
- More straightforward for packages
- Scopes: `repo`, `write:packages`, `read:packages`
- Work across all repositories you have access to

#### Fine-grained Tokens (New, More Complex)
- Repository-specific permissions
- Require explicit package permissions per repository
- May not have the right repository selected
- **More likely to cause 401 errors** if not configured correctly

**Your token might be fine-grained but not properly configured for this repo.**

### 4. 📦 Package Permissions Not Granted
Even with the right scopes, GitHub Packages has separate permissions:
- The token owner must have **write** access to the repository
- The repository must allow package publishing
- Organization settings may restrict package publishing

### 5. 👤 Username vs Organization
Check if there's a mismatch:
- Token owner: `NicoMederoReLearn` (your user)
- Repository: `NicoMederoReLearn/AndroidUSBCamera`
- If this is an organization repo, you may need organization access

### 6. 🔐 SSO/SAML Requirements
If your account is part of an organization with SSO:
- Your token needs SSO authorization
- Go to: https://github.com/settings/tokens
- Click "Configure SSO" next to your token
- Authorize it for the organization

## 🎯 How to Verify What's Wrong

### Test 1: Check Token Scopes via API
```bash
# Run this command (replace TOKEN with your actual token)
curl -I -H "Authorization: token YOUR_TOKEN" https://api.github.com/user
```

Look for the `X-OAuth-Scopes` header. It should include:
```
X-OAuth-Scopes: repo, write:packages, read:packages
```

If it says something like:
```
X-OAuth-Scopes: repo
```
Then **write:packages is missing** - that's your problem!

### Test 2: Check Token Validity
```bash
curl -H "Authorization: token YOUR_TOKEN" https://api.github.com/user
```

If you get:
- `"message": "Bad credentials"` → Token is expired or invalid
- `"message": "Requires authentication"` → Token format is wrong
- `"login": "NicoMederoReLearn"` → Token is valid

### Test 3: Check Package Registry Access
```bash
curl -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/user/packages
```

If you get 403 or 401 → Token doesn't have package permissions

## 🔧 How to Fix It

### Option 1: Update Existing Token Scopes (Can't Do This!)
**Important:** GitHub doesn't allow editing token scopes after creation.
You **MUST create a new token**.

### Option 2: Create New Classic Token (RECOMMENDED)

1. **Go to:** https://github.com/settings/tokens
2. **Click:** "Generate new token" → "Generate new token (classic)"
3. **Set:**
   - Note: `AndroidUSBCamera Packages - Nov 2024`
   - Expiration: `No expiration` (or 1 year)
4. **Select scopes:**
   ```
   ☑️ repo                    (Full control of private repositories)
      ☑️ repo:status          (Access commit status)
      ☑️ repo_deployment      (Access deployment status)
      ☑️ public_repo          (Access public repositories)
      ☑️ repo:invite          (Access repository invitations)
      ☑️ security_events      (Read and write security events)
   
   ☑️ write:packages          (Upload packages to GitHub Package Registry)
   ☑️ read:packages           (Download packages from GitHub Package Registry)
   ```
5. **Click:** "Generate token"
6. **COPY THE TOKEN IMMEDIATELY** (you won't see it again!)

### Option 3: Create Fine-grained Token (Advanced)

1. **Go to:** https://github.com/settings/tokens?type=beta
2. **Click:** "Generate new token"
3. **Set:**
   - Token name: `AndroidUSBCamera Packages`
   - Expiration: 1 year
   - Repository access: `Only select repositories` → Select `AndroidUSBCamera`
4. **Permissions:**
   - Repository permissions:
     - Contents: `Read and write`
     - Metadata: `Read-only`
   - Account permissions:
     - Packages: `Read and write` ← **CRITICAL**
5. **Generate token**

## 🚨 Common Mistakes That Cause 401

### Mistake 1: Only `repo` scope
```
❌ Scopes: repo
✅ Scopes: repo, write:packages, read:packages
```

### Mistake 2: Wrong token type
```
❌ Using a fine-grained token without package permissions
✅ Using a classic token with write:packages
```

### Mistake 3: Token for wrong account
```
❌ Token belongs to a different GitHub account
✅ Token belongs to NicoMederoReLearn
```

### Mistake 4: Expired token
```
❌ Token created 90 days ago with 90-day expiration
✅ New token or no expiration
```

### Mistake 5: SSO not authorized
```
❌ Organization requires SSO, token not authorized
✅ Token has SSO configured for the organization
```

## 📊 Debug Checklist

Run through this checklist:

- [ ] Token is a **Classic** token (not fine-grained)
- [ ] Token has `repo` scope
- [ ] Token has `write:packages` scope ← **MOST IMPORTANT**
- [ ] Token has `read:packages` scope
- [ ] Token belongs to `NicoMederoReLearn`
- [ ] Token hasn't expired
- [ ] Token format is correct: `ghp_` followed by ~40 characters
- [ ] No spaces or line breaks in `local.properties`
- [ ] You have write access to `NicoMederoReLearn/AndroidUSBCamera` repository

## 🎯 Quick Diagnosis

**If your token was created for general Git operations (push/pull), it probably only has `repo` scope.**

GitHub Packages is a **separate service** that requires separate permissions. A token with `repo` scope can clone/push code, but **cannot publish packages**.

## ✅ Solution Summary

1. Your existing token likely only has `repo` scope
2. It's missing `write:packages` and `read:packages` scopes
3. You cannot add scopes to existing tokens
4. You must create a NEW token with all three scopes:
   - `repo`
   - `write:packages`
   - `read:packages`

## 🔗 Quick Links

- Create Classic Token: https://github.com/settings/tokens/new
- Create Fine-grained Token: https://github.com/settings/tokens?type=beta
- View Existing Tokens: https://github.com/settings/tokens
- Package Registry Docs: https://docs.github.com/en/packages

---

**Bottom Line:** Your token works for Git operations but doesn't have package publishing permissions. Create a new Classic token with `write:packages` scope.

