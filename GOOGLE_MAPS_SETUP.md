# การตั้งค่า Google Maps สำหรับ Flutter App

## สิ่งที่ต้องทำเพื่อให้แผนที่ทำงาน

### 1. สร้าง Google Maps API Key

1. ไปที่ [Google Cloud Console](https://console.cloud.google.com/)
2. สร้างโปรเจกต์ใหม่หรือเลือกโปรเจกต์ที่มีอยู่
3. เปิดใช้งาน Google Maps API:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API (ถ้าต้องการค้นหาสถานที่)
4. ไปที่ Credentials และสร้าง API Key ใหม่
5. จำกัดการใช้งาน API Key (แนะนำ):
   - สำหรับ Android: จำกัดด้วย package name
   - สำหรับ iOS: จำกัดด้วย bundle ID

### 2. ตั้งค่า Android

ในไฟล์ `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- เปลี่ยน YOUR_API_KEY_HERE เป็น API Key จริง -->
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_ACTUAL_API_KEY_HERE"/>
```

### 3. ตั้งค่า iOS (ถ้าต้องการรองรับ iOS)

สร้างไฟล์ `ios/Runner/AppDelegate.swift` และเพิ่ม:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_ACTUAL_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 4. ทดสอบการทำงาน

1. เปิดแอป
2. ไปที่แท็บ "แผนที่"
3. อนุญาตการเข้าถึงตำแหน่ง
4. ควรเห็นแผนที่พร้อมจุดต่างๆ

### 5. ฟีเจอร์ที่มีในแผนที่

- 📍 แสดงตำแหน่งปัจจุบันของ Rider (จุดสีน้ำเงิน)
- 🟢 จุดรับสินค้า (จุดสีเขียว) 
- 🔴 จุดส่งสินค้า (จุดสีแดง)
- 🗺️ ปุ่มค้นหาตำแหน่งปัจจุบัน
- 🔄 ปุ่มรีเฟรชออเดอร์
- 📊 จำนวนงานที่มีอยู่
- 📱 คลิกที่จุดเพื่อดูรายละเอียดออเดอร์

### 6. หมายเหตุสำคัญ

- **ค่าใช้จ่าย**: Google Maps API มีการเรียกเก็บเงิน ตรวจสอบราคาก่อนใช้งานจริง
- **Quota**: ตั้งค่า quota limit เพื่อควบคุมค่าใช้จ่าย
- **Security**: อย่าเปิดเผย API Key ใน code repository
- **Testing**: ใช้ API key แยกสำหรับ development และ production

### 7. การแก้ไขปัญหาที่อาจเกิด

**ปัญหา**: แผนที่ไม่แสดง
- ✅ ตรวจสอบ API Key ถูกต้อง
- ✅ ตรวจสอบเปิดใช้งาน Google Maps API แล้ว
- ✅ ตรวจสอบ internet connection
- ✅ ตรวจสอบ API quota ไม่เกิน

**ปัญหา**: ไม่สามารถหาตำแหน่งได้
- ✅ ตรวจสอบอนุญาตการเข้าถึงตำแหน่งแล้ว
- ✅ ตรวจสอบ GPS เปิดอยู่
- ✅ ลองใช้งานในที่เปิดโล่ง (ไม่ใช่ในอาคาร)

**ปัญหา**: บิลด์ไม่ผ่าน
- ✅ รัน `flutter clean && flutter pub get`
- ✅ ตรวจสอบ dependencies ใน pubspec.yaml
- ✅ ตรวจสอบ Android/iOS configuration
