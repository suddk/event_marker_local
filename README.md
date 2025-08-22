# event_marker_local

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

### 📌 Steps to Run the App Locally

1. **Install Flutter SDK**

   * Download from: [Flutter official site](https://docs.flutter.dev/get-started/install)
   * Add Flutter to your system PATH.
   * Verify install:

     ```bash
     flutter doctor
     ```

     Fix any issues it reports (esp. with Android/iOS toolchains).

2. **Install Dart (comes with Flutter)**
   No extra step needed — Dart is bundled with Flutter.

3. **Set up your IDE**

   * Recommended: **VS Code** (with Flutter + Dart plugins) or **Android Studio**.
   * Xcode is required if running on iOS (Mac only).

4. **Clone or Extract the Project**

   * If zipped: extract into a folder.
   * If GitHub:

     ```bash
     git clone <repo_url>
     cd event_marker
     ```

5. **Install Dependencies**
   From project root:

   ```bash
   flutter pub get
   ```

6. **Set up Platforms**

   * For Android: ensure an emulator or device is connected.
   * For iOS: open `ios/` in Xcode at least once to resolve dependencies.

7. **Run the App**

   ```bash
   flutter run
   ```

   (this auto-detects connected devices or emulators)

8. **Build for Platforms (optional)**

   * Android APK:

     ```bash
     flutter build apk --release
     ```
   * iOS build (Mac only):

     ```bash
     flutter build ios --release
     ```

---

⚠️ Since your project is “No Firebase”, the above should work directly (no `google-services.json` / `GoogleService-Info.plist` needed).

Do you want me to draft this README section in **Markdown format** (ready to paste in your repo), or just keep it as plain text?
