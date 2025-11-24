# AndroidUSBCamera - ReLearn Fork

This is a modernized fork of [AndroidUSBCamera](https://github.com/jiangdongguo/AndroidUSBCamera) by ReLearn, updated to work with the latest Android development tools and Google Play Store requirements.

## Changes from Original

### Build System Updates (November 2024)
- **Upgraded to Android Gradle Plugin 8.2.2** (from 4.2.2)
- **Upgraded Gradle to 8.2** (from 8.5)
- **Upgraded Kotlin to 1.9.22** (from 1.5.20)
- **Updated CMake to 3.22.1** for native library builds
- **Replaced deprecated jcenter()** with mavenCentral()

### Google Play Store Compliance
- **Added 16KB page size support** for modern Android devices
  - Added `ANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES` flag in CMake
  - Added manifest property for 16KB page size support
- **Updated target SDK to 34** (Google Play requirement)
- **Updated minimum SDK to 21** (for modern library compatibility)

### Modernization
- **Added namespace declarations** for all modules (AGP 8+ requirement)
- **Removed deprecated package attributes** from AndroidManifest files
- **Fixed Maven publishing** configuration for AGP 8+
- **Updated dependency versions**:
  - immersionbar: 3.0.0 → 3.2.2
  - webpdecoder: updated to working fork
  - mmkv: 1.2.12 → 1.3.9
  - Glide: 4.10.0 → 4.16.0
- **Added multidex support**

### Package Naming
Updated groupId for publishing to:
```
com.nando.androidusbcamera
```

Modules:
- `com.nando.ausbc` - Main USB camera library
- `com.nando.uvc` - UVC protocol implementation
- `com.nando.natives` - Native libraries (YUV, MP3 encoding)

## Building the Project

```bash
./gradlew assembleDebug
```

The project now builds successfully with:
- ✅ Android Gradle Plugin 8.2.2
- ✅ Gradle 8.2
- ✅ Kotlin 1.9.22
- ✅ Target SDK 34 (Google Play compliant)
- ✅ 16KB page size support

## Features (from original)

- Support opening multi-road camera
- Support opening UVC camera on Android 4.4+ (now 5.0+)
- Support previewing 480p, 720p, 1080p, etc.
- Support adding effects with OpenGL ES 2.0
- Support capture photo (.jpg), video (.mp4/.h264/.yuv) and audio (pcm/mp3/aac)
- Support rotating camera view
- Support offscreen rendering
- Support recording media along with acquiring YUV/RGBA/PCM/H.264/AAC stream
- Support acquiring all resolutions and USB devices
- Support acquiring system or device mic (UAC) audio data
- Support armeabi-v7a, arm64-v8a, x86 & x86_64

## Usage

Add to your `build.gradle`:

```groovy
dependencies {
    implementation 'com.nando.androidusbcamera:libausbc:3.3.5'
}
```

For detailed usage instructions, see the [original README](README.md).

## Native Library Support

This fork includes 16KB page size support in native libraries, making it compatible with devices using 16KB memory pages (required by Google Play Store from 2025).

The CMake configuration includes:
```cmake
-DANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=ON
```

## License

Apache License 2.0 - See [LICENSE](LICENSE) file

## Credits

- Original project: [jiangdongguo/AndroidUSBCamera](https://github.com/jiangdongguo/AndroidUSBCamera)
- Fork maintained by: [ReLearn](https://github.com/NicoMederoReLearn)

