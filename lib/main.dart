import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initialize();
  runApp(const GeminiChat());
}

class GeminiChat extends StatefulWidget {
  const GeminiChat({super.key});

  @override
  State<GeminiChat> createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {

  void _onSettingsChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Config.settingsService.addListener(_onSettingsChange);
  }

  @override
  void dispose() {
    Config.settingsService.removeListener(_onSettingsChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Config.settingsService.settings;
    final seedColor = Config.settingsService.seedColor;

    return MaterialApp(
      title: 'Gemini Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark
        ),
        useMaterial3: true,
      ),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
