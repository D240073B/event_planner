# Event Planner AI - User Guide

This guide will help you set up and run the Event Planner AI application.

## Prerequisites

Before you begin, ensure you have the following installed and set up:

1.  **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install).
2.  **Firebase Account**: A Google account to access [Firebase Console](https://console.firebase.google.com/).
3.  **Hugging Face Account**: An account to get an API token for image generation.

---

## 1. Setup & Installation

1.  **Clone the Repository**:
    ```bash
    git clone <repository-url>
    cd event_planner
    ```

2.  **Install Dependencies**:
    Run the following command in the project root:
    ```bash
    flutter pub get
    ```

---

## 2. Configuration

### Firebase Setup
The app uses Firebase AI Logic (Gemini) for event suggestions.

1.  Create a new project in the [Firebase Console](https://console.firebase.google.com/).
2.  Enable **Firebase AI Logic** (Vertex AI for Firebase) in the Build section.
3.  Register your app (Android/iOS) in the Firebase project settings.
4.  Download the configuration files:
    -   **Android**: Place `google-services.json` in `android/app/`.
    -   **iOS**: Place `GoogleService-Info.plist` in `ios/Runner/`.
5.  Follow the Firebase documentation to add the necessary plugins to your native projects if they are not already there.

### Hugging Face API Token
The app uses Hugging Face for image generation.

1.  Go to [Hugging Face Settings](https://huggingface.co/settings/tokens).
2.  Create a new **Access Token** (Role: Read).
3.  Open `lib/services/image_generation_service.dart`.
4.  Replace `YOUR_HUGGING_FACE_API_TOKEN` with your actual token:
    ```dart
    static const String _apiToken = 'your_actual_token_here';
    ```

---

## 3. Running the App

1.  **Start an Emulator or Connect a Device**:
    -   Use Android Studio, VS Code, or the terminal to list devices: `flutter devices`.
2.  **Run the App**:
    ```bash
    flutter run
    ```

---

## 4. Usage Flow

1.  **Input Details**: On the home screen, enter the event name, location, date, theme, and number of participants.
2.  **Generate Plan**: Tap "Generate Suggestion". The AI will create a poster and provide suggestions.
3.  **Review Results**: View the generated poster and the detailed planning suggestions (agenda, food, activities) on the results screen.

---

## Troubleshooting

-   **Firebase Initialization Error**: Ensure `google-services.json` or `GoogleService-Info.plist` is correctly placed and matches your Firebase project.
-   **Image Generation Failed**: Check your Hugging Face API token and internet connection.
-   **AI Suggestions Slow**: The Gemini model may take a few seconds to respond. Ensure your Firebase project has the Gemini API enabled.
