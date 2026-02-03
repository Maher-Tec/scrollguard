# 🛡️ ScrollGuard

> **Mindful moments for digital wellness.**

ScrollGuard is a powerful Flutter application designed to help users break free from doom-scrolling and regain control over their digital lives. By monitoring usage of addictive apps and triggering mindful interventions, ScrollGuard gently nudges users back to reality.

<div align="center">
  <img src="screens/image.png" width="200" />
  <img src="screens/image copy.png" width="200" />
  <img src="screens/image copy 2.png" width="200" />
  <img src="screens/image copy 3.png" width="200" />
</div>

---

## ✨ Features

-   **🧠 Intelligent Monitoring**: Automatically tracks time spent on social media apps (Instagram, TikTok, YouTube, Facebook, Snapchat).
-   **🛑 Mindful Interventions**: Triggers a calming "intervention" screen when usage limits are reached, forcing a pause.
-   **🌬️ Breathing Exercises**: Integrated breathing guide to help reduce anxiety and reset focus.
-   **📊 Usage Analytics**: Track your daily scrolling time and streaks.
-   **🎨 Premium Design**: Beautiful dark-mode UI with glassmorphism effects, smooth animations (`flutter_animate`), and a cinematic intro.
-   **⚡ Native Integration**: Uses Android Accessibility Services and Usage Stats for precise tracking and overlay capabilities.

## 🛠️ Tech Stack

-   **Framework**: [Flutter](https://flutter.dev/)
-   **Language**: [Dart](https://dart.dev/) & [Kotlin](https://kotlinlang.org/) (for native services)
-   **State Management**: [Riverpod](https://riverpod.dev/)
-   **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
-   **Animations**: [Flutter Animate](https://pub.dev/packages/flutter_animate)
-   **Video**: [Video Player](https://pub.dev/packages/video_player)
-   **Local Storage**: [Shared Preferences](https://pub.dev/packages/shared_preferences)

## 📸 Screenshots

| Onboarding | Dashboard | Permission Setup | Interventions |
|:---:|:---:|:---:|:---:|
| <img src="screens/image.png" width="200" /> | <img src="screens/image copy.png" width="200" /> | <img src="screens/image copy 2.png" width="200" /> | <img src="screens/image copy 3.png" width="200" /> |

## 🚀 Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/scrollguard.git
    cd scrollguard
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Generate Assets & Icons** (Optional)
    ```bash
    dart run flutter_launcher_icons
    ```

4.  **Run the app**
    ```bash
    flutter run
    ```
    *Note: This app requires an Android device to function fully due to specific native APIs (Usage Stats, Accessibility).*

## 📱 Permissions

ScrollGuard requires specific permissions to function:
*   **Usage Access**: To monitor how long you use specific apps.
*   **Display Over Apps**: To show the intervention screen over other apps.
*   **Accessibility Service**: To detect when you open/close apps in real-time.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1.  Fork the project
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

<center>
  <sub>Built with ❤️ using Flutter</sub>
</center>
