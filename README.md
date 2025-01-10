# lono_scan

ສະບາຍດີ🙏🏻🙏🏻🙏🏻

- use `LonoScanView` in widget to show scan view.
- custom identifiable area.
- decode qrcode from image path by `LonoScan.parse`.

### Prepare

##### ios
info.list
```
<key>NSCameraUsageDescription</key>
<string>Your Description</string>

<key>io.flutter.embedded_views_preview</key>
<string>YES</string>
```
##### android
```xml
<uses-permission android:name="android.permission.CAMERA" />

<application>
  <meta-data
    android:name="flutterEmbedding"
    android:value="2" />
</application>
```

```yaml
lono_scan: ^newest
```
```dart
import 'package:lono_scan/lono_scan.dart';
```

### Usage

- show scan view in widget 
```dart
LonoScanController controller = LonoScanController();
String qrcode = '';

Container(
  width: 350, //  Custom wrap size 
  height: 350,
  child: LonoScanView(
    controller: controller,
// Custom scan area, if set to 1.0, will scan full area
    scanAreaScale: .8,
    scanLineColor: Colors.green.shade400,
    onCapture: (data) {
      // do something
    },
  ),
),
```
- you can use `controller.resume()` and `controller.pause()` resume/pause camera

```dart
controller.resume();
controller.pause();
```
- get qrcode string from image path
```dart
String result = await LonoScan.parse(imagePath);
```
- toggle flash light
```dart
controller.toggleTorchMode();
```
- dispose 
```dart
controller.dispose();
```
### Proguard-rules
```
-ignorewarnings
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keep class com.huawei.hianalytics.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}
```

# Credit
Package lono_scan is an update from Package scan.
Original Package Link ::=> https://pub.dev/packages/scan

# License
MIT License





