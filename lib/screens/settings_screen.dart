import 'package:flutter/material.dart';
import '../services/settings_services.dart';
import '../config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsServices get _settingsService => Config.settingsService;
  TextEditingController? _apiKeyController;
  TextEditingController? _modelNameController;

  bool _isDarkMode = true;
  Color _seedColor = Colors.greenAccent;
  bool _isLoading = false;
  bool _obscureApiKey = true;

  final List<Color> _availableColors = [
    Colors.greenAccent,
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.red,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _settingsService.addListener(_onSettingsChanged);

  }

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    _apiKeyController?.dispose();
    _modelNameController?.dispose();
    super.dispose();
  }

  Future _loadSettings() async {
    final settings = _settingsService.settings;

    setState(() {
      _apiKeyController = TextEditingController(text: settings.geminiApiKey);
      _modelNameController = TextEditingController(text: settings.modelName);
      _isDarkMode = settings.isDarkMode;
      _seedColor = _settingsService.seedColor;
    });
  }

  void _onSettingsChanged() {
    if (!mounted || _apiKeyController == null || _modelNameController == null) {
      return;
    }

    final settings = _settingsService.settings;

    setState(() {
      if (_apiKeyController!.text != settings.geminiApiKey) {
        _apiKeyController!.text = settings.geminiApiKey;
      }

      if (_modelNameController!.text != settings.modelName) {
        _modelNameController!.text = settings.geminiApiKey;
      }

      if (_modelNameController!.text != settings.modelName)  {
        _modelNameController!.text = settings.modelName;
      }
      _isDarkMode = settings.isDarkMode;
      _seedColor = _settingsService.seedColor;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }


  Future<void> _saveAPIKey() async {
    if (_apiKeyController == null || _apiKeyController!.text.trim().isEmpty) {
      _showSnackBar('API key cannot be empty');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _settingsService.updateApiKey(_apiKeyController!.text.trim());
      _showSnackBar('API key saved successfully');
    } catch (e) {
      _showSnackBar('Failed to save API key ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _savedModelName() async {
    if (_modelNameController == null || _modelNameController!.text.trim().isEmpty) {
      _showSnackBar('Model name cannot be empty');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _settingsService.updateModelName(_modelNameController!.text.trim());
      _showSnackBar('Model name saved successfully');
    } catch (e) {
      _showSnackBar('Failed to save model name: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    setState(() => _isLoading = true );
    try {
      await _settingsService.updateDarkMode(value);
      setState(() => _isDarkMode = value);
      _showSnackBar('Theme updated');
    } catch (e) {
      _showSnackBar('Failed to update theme: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateSeedColor(Color color) async {
    setState(() => _isLoading = true);

    try {
      await _settingsService.updateSeedColor(color);
      setState(() => _seedColor = color);
      _showSnackBar("Theme color updated");
    } catch (e) {
      _showSnackBar('Failed to update color: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Settings')),
        // backgroundColor: ,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _geminiAPIConfig(colorScheme: colorScheme),
          const SizedBox(height: 24),
          _modelConfigSection(colorScheme: colorScheme),
          const SizedBox(height: 24),
          _appearance(colorScheme: colorScheme),
          const SizedBox(height: 24),
          _about(colorScheme: colorScheme)
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _geminiAPIConfig({required ColorScheme colorScheme}) {
    return _buildSection(
      title: 'Gemini API Configuration',
      icon: Icons.key,
      children: [
        const SizedBox(height: 8),
        TextField(
          controller: _apiKeyController,
          decoration: InputDecoration(
            labelText: 'API Key',
            hintText: 'Enter your Gemini API key',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _obscureApiKey
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureApiKey = !_obscureApiKey;
                    });
                  },
                  tooltip: _obscureApiKey
                      ? 'Show API Key'
                      : 'Hide API key',
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveAPIKey,
                  tooltip: 'Save API key',
                )
              ],
            ),
          ),
          obscureText:
          _obscureApiKey &&
              (_apiKeyController?.text ?? '') != 'YOUR_API_KEY_HERE',
          onSubmitted: (_) => _saveAPIKey(),
        ),
        const SizedBox(height: 8),
        Text(
          'Get your API key from: https://ai.google.dev/',
          style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.5)
          ),
        )
      ],
    );
  }

  Widget _modelConfigSection({required ColorScheme colorScheme}) {
    return _buildSection(
        title: 'Model Configuration',
        icon: Icons.smart_toy,
        children: [
          const SizedBox(height: 8),
          TextField(
            controller: _modelNameController,
            decoration: InputDecoration(
                labelText: 'Model Name',
                hintText: 'e.g., gemini-2.5-flash, gemini-pro',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _savedModelName,
                  tooltip: 'Save Model Name',
                )
            ),
            onSubmitted: (_) => _savedModelName(),
          ),
          const SizedBox(height: 8),
          Text(
            'Current model: ${_modelNameController?.text ?? 'Not Set'}',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          Text(
            'Popular Models can be found at: https://ai.google.dev/gemini-api/docs/models',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          )
        ]
    );
  }

  Widget _appearance({required ColorScheme colorScheme}) {
    return _buildSection(
        title: 'Appearance',
        icon: Icons.palette,
        children: [
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: Text(
              _isDarkMode
                  ? 'Dark theme enabled'
                  : 'Light theme enabled'
            ),
            value: _isDarkMode,
            onChanged: _isLoading ? null : _toggleDarkMode,
            secondary: Icon(
              _isDarkMode ? Icons.dark_mode : Icons.light_mode
            ),
          ),

          const SizedBox(height: 16,),

          Text(
            'Theme Color',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _availableColors.map((color){
              final isSelected = color.toARGB32() == _seedColor.toARGB32();
              return GestureDetector(
                onTap: _isLoading ? null : () => _updateSeedColor(color),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? colorScheme.primary : Colors.transparent,
                      width: 3
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2
                      )
                    ] : null,
                  ),
                  child: isSelected ?
                  Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24
                  ) : null,
                ),
              );
            }).toList(),

          ),
        ]
    );
  }

  Widget _about({required ColorScheme colorScheme}) {
    return _buildSection(
      title: 'About',
      icon: Icons.info,
      children: [
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.code),
          title: const Text('App Version'),
          subtitle: const Text('0.0.1'),
        ),
        ListTile(
          leading: const Icon(Icons.api),
          title: const Text('App Provider'),
          subtitle: const Text('Google Gemini'),
        ),
      ]
    );
  }
}
