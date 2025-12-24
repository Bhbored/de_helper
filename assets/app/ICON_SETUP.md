# App Icon Setup Instructions

## ✅ Quick Setup

After adding your `app_icon.png` file to `assets/app/`, run these commands:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

This will automatically generate all required icon sizes for both Android and iOS!

## 📝 What This Does

The `flutter_launcher_icons` package will:
- Generate all Android icon sizes in `android/app/src/main/res/mipmap-*/`
- Generate all iOS icon sizes in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Create adaptive icons for Android
- Update all necessary configuration files

## 🔧 Configuration

The icon configuration is in `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/app/app_icon.png"
  min_sdk_android: 21
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/app/app_icon.png"
```

### To Change Icon Settings:

- **Change icon file path:** Update `image_path` in `pubspec.yaml`
- **Change adaptive icon background color:** Update `adaptive_icon_background` (currently white: `#ffffff`)
- **Disable iOS/Android:** Set `ios: false` or `android: false`

## ⚠️ Important Notes

- Your `app_icon.png` should be at least 1024x1024 pixels
- After running `flutter pub run flutter_launcher_icons`, rebuild your app
- If icons don't update, try: `flutter clean` then rebuild

