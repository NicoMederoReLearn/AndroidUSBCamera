# GitHub Packages Publishing Guide

## Overview
Your AndroidUSBCamera library is now configured to publish to GitHub Packages. This allows you to use it as a dependency in other projects.

## 🚀 Quick Start - Publish Now

### Method 1: Using GitHub Actions (Recommended)

1. **Commit and push the changes:**
   ```bash
   cd /Users/elhopaness/Documents/Laburo/ReLearn/AndroidUSBCamera
   git add .
   git commit -m "Configure GitHub Packages publishing"
   git push origin master
   ```

2. **Trigger the workflow:**
   - Go to: https://github.com/NicoMederoReLearn/AndroidUSBCamera/actions
   - Click on "Publish to GitHub Packages" workflow
   - Click "Run workflow" button
   - Select branch: `master`
   - Click "Run workflow"

3. **Wait for completion** (usually 5-10 minutes)
   - The workflow will build and publish all three libraries
   - Check progress in the Actions tab

### Method 2: Publish Locally

1. **Create a Personal Access Token:**
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Name: `AndroidUSBCamera Publishing`
   - Scopes: Check `write:packages` and `read:packages`
   - Click "Generate token"
   - **SAVE THE TOKEN** - you won't see it again!

2. **Add credentials to local.properties:**
   ```bash
   echo "gpr.user=NicoMederoReLearn" >> local.properties
   echo "gpr.token=YOUR_TOKEN_HERE" >> local.properties
   ```
   
   Replace `YOUR_TOKEN_HERE` with your actual token.

3. **Publish the libraries:**
   ```bash
   ./gradlew publish
   ```

## 📦 Using Your Published Packages

### In Another Android Project

1. **Add GitHub Packages repository** (in `settings.gradle` or root `build.gradle`):
   ```groovy
   repositories {
       google()
       mavenCentral()
       maven {
           url = uri("https://maven.pkg.github.com/NicoMederoReLearn/AndroidUSBCamera")
           credentials {
               username = System.getenv("GITHUB_ACTOR") ?: project.findProperty("gpr.user")
               password = System.getenv("GITHUB_TOKEN") ?: project.findProperty("gpr.token")
           }
       }
   }
   ```

2. **Add your GitHub credentials** to `local.properties`:
   ```properties
   gpr.user=YOUR_GITHUB_USERNAME
   gpr.token=YOUR_PERSONAL_ACCESS_TOKEN
   ```

3. **Add dependencies** (in `app/build.gradle`):
   ```groovy
   dependencies {
       // Main library (includes libnative)
       implementation 'com.nando.androidusbcamera:libausbc:3.3.5'
       
       // Or add individual modules:
       // implementation 'com.nando.androidusbcamera:libuvc:3.3.5'
       // implementation 'com.nando.androidusbcamera:libnative:3.3.5'
   }
   ```

## 🔍 Verify Publication

After publishing, check your packages:
- Go to: https://github.com/NicoMederoReLearn/AndroidUSBCamera
- Click "Packages" on the right sidebar
- You should see three packages:
  - `libausbc`
  - `libuvc`
  - `libnative`

## 📋 Published Packages

### com.nando.androidusbcamera:libausbc:3.3.5
Main USB camera library with all features.

### com.nando.androidusbcamera:libuvc:3.3.5
UVC protocol implementation.

### com.nando.androidusbcamera:libnative:3.3.5
Native libraries for YUV processing and MP3 encoding.
- ✅ 16KB page size support
- ✅ ARM, ARM64, x86, x86_64 architectures

## 🔄 Publishing Updates

To publish a new version:

1. **Update version in `build.gradle`:**
   ```groovy
   ext {
       versionNameString = '3.3.6'  // Increment version
       versionCode = 127            // Increment code
   }
   ```

2. **Commit and create a release:**
   ```bash
   git add .
   git commit -m "Bump version to 3.3.6"
   git tag v3.3.6
   git push origin master --tags
   ```

3. **Create GitHub Release:**
   - Go to: https://github.com/NicoMederoReLearn/AndroidUSBCamera/releases/new
   - Tag: `v3.3.6`
   - Title: `v3.3.6 - Your changes description`
   - Click "Publish release"
   - This will automatically trigger the publishing workflow

## 🛠️ Troubleshooting

### "Could not resolve dependency"
- Make sure you've added GitHub Packages repository
- Check your GitHub token has `read:packages` permission
- Verify your credentials in `local.properties`

### "401 Unauthorized" when publishing
- Verify your token has `write:packages` permission
- Make sure token hasn't expired
- Check username is correct (case-sensitive)

### Workflow fails
- Check the Actions tab for error logs
- Ensure all dependencies are available
- Verify the repository has Actions enabled

## 🔒 Security Notes

- **Never commit `local.properties`** - it's already in `.gitignore`
- GitHub tokens should be kept secret
- Use environment variables for CI/CD
- Rotate tokens periodically

## 📚 Additional Resources

- [GitHub Packages Documentation](https://docs.github.com/en/packages)
- [Maven Publish Plugin](https://docs.gradle.org/current/userguide/publishing_maven.html)
- [Android Library Publishing](https://developer.android.com/studio/build/maven-publish-plugin)

---

## ✅ Next Steps

1. ✅ Configuration completed
2. 📤 **Publish packages** (use Method 1 or 2 above)
3. 🔍 **Verify publication** on GitHub
4. 🎯 **Use in your project**

**Ready to publish!** Choose a method above and let's get your packages live.

