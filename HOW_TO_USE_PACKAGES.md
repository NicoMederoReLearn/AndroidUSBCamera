# 📦 How to Use Your Published Packages in Other Projects

## The Problem

You're getting:
```
Failed to resolve: com.nando.androidusbcamera:libausbc:3.3.8-rc1
```

**Cause:** GitHub Packages requires authentication even for downloading packages, unlike Maven Central or JitPack.

## ✅ Solution: Add GitHub Packages Repository with Authentication

### Step 1: Add Credentials to the Other Project

In your **other project**, create or update `local.properties`:

```properties
github.actor=NicoMederoReLearn
github.token=YOUR_GITHUB_TOKEN
```

**Important:** Use the SAME token you used for publishing (or any token with `read:packages` scope).

### Step 2: Load local.properties in build.gradle

In your **other project's root `build.gradle` or `settings.gradle`**, add this at the TOP:

```groovy
// Load local.properties for GitHub credentials
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withInputStream { localProperties.load(it) }
}

// Make properties available
ext.set("github.actor", localProperties.getProperty("github.actor", ""))
ext.set("github.token", localProperties.getProperty("github.token", ""))
```

### Step 3: Add GitHub Packages Repository

**Option A: In `settings.gradle` (Recommended for newer projects):**

```groovy
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        
        // Add GitHub Packages repository
        maven {
            url = uri("https://maven.pkg.github.com/NicoMederoReLearn/AndroidUSBCamera")
            credentials {
                username = settings.ext.get("github.actor")
                password = settings.ext.get("github.token")
            }
        }
    }
}
```

**Option B: In root `build.gradle` (For older projects):**

```groovy
allprojects {
    repositories {
        google()
        mavenCentral()
        
        // Add GitHub Packages repository
        maven {
            url = uri("https://maven.pkg.github.com/NicoMederoReLearn/AndroidUSBCamera")
            credentials {
                username = project.ext.get("github.actor")
                password = project.ext.get("github.token")
            }
        }
    }
}
```

### Step 4: Add Dependency (Already Done)

Your `libs.versions.toml` looks correct:

```toml
[versions]
nandoUsbCamera = "3.3.8-rc1"

[libraries]
androidUsbCamera = { module = "com.nando.androidusbcamera:libausbc", version.ref = "nandoUsbCamera" }
```

Then in `app/build.gradle`:

```groovy
dependencies {
    implementation libs.androidUsbCamera
}
```

### Step 5: Sync and Build

```bash
./gradlew --refresh-dependencies
./gradlew clean build
```

---

## 🔧 Complete Setup Example

Here's the complete setup for your other project:

### File: `local.properties`
```properties
sdk.dir=/path/to/android/sdk
github.actor=NicoMederoReLearn
github.token=ghp_your_token_here
```

### File: `settings.gradle`
```groovy
// Load local.properties
def localProperties = new Properties()
def localPropertiesFile = new File(rootProject.projectDir, 'local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withInputStream { localProperties.load(it) }
}

pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        
        // GitHub Packages - AndroidUSBCamera
        maven {
            url = uri("https://maven.pkg.github.com/NicoMederoReLearn/AndroidUSBCamera")
            credentials {
                username = localProperties.getProperty("github.actor") ?: ""
                password = localProperties.getProperty("github.token") ?: ""
            }
        }
    }
}

rootProject.name = "Your App Name"
include ':app'
```

### File: `gradle/libs.versions.toml`
```toml
[versions]
nandoUsbCamera = "3.3.8-rc1"

[libraries]
androidUsbCamera = { module = "com.nando.androidusbcamera:libausbc", version.ref = "nandoUsbCamera" }
```

### File: `app/build.gradle`
```groovy
dependencies {
    implementation libs.androidUsbCamera
    // This will automatically include libnative as it's an 'api' dependency
}
```

---

## 🔍 Troubleshooting

### Error: "Could not resolve com.nando.androidusbcamera:libausbc"

**Check 1: Credentials are set**
```bash
cat local.properties | grep github
```

Should show:
```
github.actor=NicoMederoReLearn
github.token=ghp_...
```

**Check 2: Repository is added**
Run:
```bash
./gradlew --refresh-dependencies --info | grep "maven.pkg.github.com"
```

Should show the GitHub Packages repository being checked.

**Check 3: Token has read:packages scope**
Your token needs:
- ✅ `read:packages` (to download packages)
- You can use the same token you used for publishing

### Error: "Received status code 401 from server"

Your token is missing `read:packages` scope or credentials aren't being read.

**Fix:**
1. Verify token has `read:packages` scope at https://github.com/settings/tokens
2. Make sure `local.properties` loading code is at the TOP of your gradle file
3. Try using the full property reading approach:
   ```groovy
   username = localProperties.getProperty("github.actor") ?: ""
   password = localProperties.getProperty("github.token") ?: ""
   ```

### Error: "Could not find com.nando.androidusbcamera:libausbc:3.3.8-rc1"

The version doesn't exist or repository path is wrong.

**Fix:**
1. Verify the package exists: https://github.com/NicoMederoReLearn/AndroidUSBCamera/packages
2. Check the exact version number
3. Verify repository URL matches exactly

---

## 📝 Quick Checklist

For your other project to import the library:

- [ ] `local.properties` has `github.actor` and `github.token`
- [ ] GitHub token has `read:packages` scope
- [ ] `settings.gradle` or `build.gradle` loads `local.properties`
- [ ] GitHub Packages repository is added to `repositories` block
- [ ] Repository URL is: `https://maven.pkg.github.com/NicoMederoReLearn/AndroidUSBCamera`
- [ ] Credentials are passed to the maven repository
- [ ] Run `./gradlew --refresh-dependencies`
- [ ] Sync project in Android Studio

---

## 🎯 TL;DR

In your **other project**:

1. **Add to `local.properties`:**
   ```properties
   github.actor=NicoMederoReLearn
   github.token=YOUR_TOKEN
   ```

2. **Add to top of `settings.gradle`:**
   ```groovy
   def localProperties = new Properties()
   new File(rootProject.projectDir, 'local.properties').withInputStream { localProperties.load(it) }
   ```

3. **Add repository in `settings.gradle`:**
   ```groovy
   maven {
       url = uri("https://maven.pkg.github.com/NicoMederoReLearn/AndroidUSBCamera")
       credentials {
           username = localProperties.getProperty("github.actor")
           password = localProperties.getProperty("github.token")
       }
   }
   ```

4. **Sync and build!**

---

## 🚀 Why GitHub Packages Requires Auth for Download

Unlike Maven Central or JitPack:
- ✅ Maven Central: Public packages, no auth needed
- ✅ JitPack: Public repos, no auth needed
- ❌ GitHub Packages: **Always requires auth**, even for public repos

This is a GitHub Packages limitation/design decision.

---

**Now try syncing your other project - it should work!** 🎉

