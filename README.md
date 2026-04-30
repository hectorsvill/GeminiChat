# GeminiChat

A Flutter chat application powered by Google Gemini AI. Configure your own API key, choose your preferred Gemini model, and customize the look and feel — all from within the app.

## Features

- **AI Chat** — Converse with Google Gemini directly from the app.
- **Chat History** — Browse past conversations.
- **Settings** — Configure your Gemini API key, model, and UI preferences without rebuilding the app.
  - Gemini API key (stored locally, never transmitted elsewhere)
  - Gemini model selection (default: `gemini-2.5-flash`)
  - Light / dark theme toggle
  - Theme color picker (10 accent colors)
- **Material 3** design with dynamic color schemes.
- **Persistent settings** via `shared_preferences`.

## Screenshots

> _Add screenshots here once the UI is complete._

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.10.7
- A Google Gemini API key — get one for free at <https://ai.google.dev/>

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/hectorsvill/GeminiChat.git
   cd GeminiChat
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

### Configuring your API key

On first launch, open the **Settings** tab and enter your Gemini API key in the *Gemini API Configuration* section, then tap the save icon. The key is stored locally using `shared_preferences` and is never sent anywhere other than the official Google Gemini API.

You can also change the model name in the *Model Configuration* section. A list of available models can be found at <https://ai.google.dev/gemini-api/docs/models>.

## Project Structure

```
lib/
├── main.dart                   # App entry point, theme setup
├── config.dart                 # Global config / dependency access
├── models/
│   └── settings_model.dart     # Settings data model
├── services/
│   └── settings_services.dart  # Settings persistence (SharedPreferences)
└── screens/
    ├── home_screen.dart         # Bottom-navigation host
    ├── chat_screen.dart         # AI chat screen
    ├── chat_history_screen.dart # Chat history screen
    └── settings_screen.dart     # Settings screen
```

## Dependencies

| Package | Purpose |
|---|---|
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Persist settings across app restarts |
| [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) | iOS-style icon set |

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is open source. See the repository for license details.
