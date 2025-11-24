# Changelog - ReLearn Fork

All notable changes to this fork will be documented in this file.

## [3.3.5-relearn.1] - 2024-11-24

### Build System Updates
- Upgraded Android Gradle Plugin from 4.2.2 to 8.2.2
- Upgraded Gradle from 8.5 to 8.2
- Upgraded Kotlin from 1.5.20 to 1.9.22
- Replaced deprecated `jcenter()` with `mavenCentral()`
- Removed deprecated `android-maven-gradle-plugin`
- Fixed Maven publishing configuration for AGP 8+ compatibility

### Android Platform Compliance
- Updated minimum SDK version from 19 to 21
- Updated target SDK version to 34 (Google Play requirement)
- Added 16KB page size support for native libraries
  - Added `ANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES` CMake flag
  - Added manifest property `android.app.property.SUPPORT_16KB_PAGE_SIZE`
- Updated CMake version from 3.10.2 to 3.22.1

### Module Configuration
- Added namespace declarations for all modules (AGP 8+ requirement):
  - `com.nando.ausbc` for libausbc
  - `com.nando.uvc` for libuvc
  - `com.nando.natives` for libnative
  - `com.jiangdg.demo` for app
- Removed deprecated `package` attributes from all AndroidManifest.xml files
- Updated publishing groupId to `com.nando.androidusbcamera`

### Dependency Updates
- Updated immersionbar: 3.0.0 → 3.2.2 (geyifeng.immersionbar)
- Updated webpdecoder: 1.6.4.9.0 → 2.6.4.16.0 (zjupure fork)
- Updated mmkv: 1.2.12 → 1.3.9
- Updated Glide: 4.10.0 → 4.16.0
- Added multidex support: 2.0.1

### Code Fixes
- Fixed R class references for non-transitive R classes (AGP 8+)
- Fixed Material Design R class reference in BaseBottomDialog
- Updated resource references in EffectListDialog
- Fixed Glide API compatibility issues

### Configuration
- Enabled `android.nonTransitiveRClass=true` for faster builds
- Added Gradle configuration cache support (disabled by default)
- Made gradlew executable

### Known Warnings
- Some deprecation warnings remain for backward compatibility
- CMake warning about `ANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES` on older NDK versions (can be safely ignored)
- Some CXX5304 package.xml parsing warnings (non-critical)

### Testing
- ✅ Successfully builds with Gradle 8.2 and AGP 8.2.2
- ✅ All library modules compile successfully
- ✅ Demo app compiles and packages correctly
- ✅ Native libraries build with 16KB page size support

## Original Version

This fork is based on [AndroidUSBCamera v3.3.5](https://github.com/jiangdongguo/AndroidUSBCamera) by jiangdongguo.

