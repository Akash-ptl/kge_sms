# KGE SMS Gateway (Vantage Gateway)

A high-performance Flutter application that transforms an Android device into a professional SMS monitoring and telemetry node.

## 📡 Overview
Vantage Gateway is designed to monitor SMS traffic, audit SIM card hardware, and broadcast GPS telemetry. It is built for reliability and runs as a foreground service to ensure constant uptime.

## ⚡ Key Features
- **SMS Monitoring**: Real-time tracking and logging of incoming and outgoing SMS messages.
- **SIM Hardware Auditing**: Access detailed information about the SIM carrier and cellular network state.
- **GPS Telemetry**: Automatically send location updates at configurable time intervals.
- **Background Service**: Uses Android Foreground Services to stay active even when the app is in the background.
- **Industrial Dashboard**: A clean, technical interface for monitoring all system activities in real-time.

## 📸 Screenshots

| Welcome | Permissions | SMS Audit |
|--|--|--|
| <img src="./assets/screenshots/01_onboarding_welcome.png" width="300"> | <img src="./assets/screenshots/02_permissions_intro.png" width="300"> | <img src="./assets/screenshots/03_permission_sms.png" width="300"> |

| Location | Permissions Final | Number Entry |
|--|--|--|
| <img src="./assets/screenshots/04_permission_location.png" width="300"> | <img src="./assets/screenshots/05_permission_final.png" width="300"> | <img src="./assets/screenshots/06_number_entry.png" width="300"> |

| Monitoring Dashboard |
|--|
| <img src="./assets/screenshots/07_dashboard.png" width="600"> |

## 🛠️ Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: GetX
- **Native Integration**: Kotlin (Method Channels for SMS & SIM data)
- **Background Tasks**: Flutter Foreground Task
- **Animations**: Flutter Animate

## 🚀 Getting Started
1. **Clone the project**:
   ```bash
   git clone https://github.com/Akash-ptl/kge_sms.git
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   flutter run
   ```

---
**Note**: This app requires SMS, SIM, and Location permissions to function correctly as a gateway node.
