import 'package:flutter/material.dart';

class SettingsModel {
  final String geminiApiKey;
  final String modelName;
  final bool isDarkMode;
  final int seedColorValue;

  SettingsModel({
    required this.geminiApiKey,
    required this.modelName,
    required this.isDarkMode,
    required this.seedColorValue,

  });

  factory SettingsModel.defaults() {
    return SettingsModel(
        geminiApiKey: 'YOUR_API_KEY_HERE',
        modelName: 'gemini-2.5-flash',
        isDarkMode: true,
        seedColorValue: Colors.greenAccent.toARGB32()
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic>json) {
    return SettingsModel(
        geminiApiKey: json['geminiApiKey'] ?? 'YOUR_API_KEY',
        modelName: json['modelName'] ?? 'gemini-2.5-flash',
        isDarkMode: json['isDarkMode'] ?? true,
        seedColorValue: json['seedColorValue'] ?? Colors.greenAccent.toARGB32()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'geminiApiKey': geminiApiKey,
      'modelName': modelName,
      'isDarkMode': isDarkMode,
      'seedColorValue': seedColorValue,
    };
  }

  SettingsModel copyWith({
    String? geminiApiKey,
    String? modelName,
    bool? isDarkMode,
    int? seedColorValue,
  }) {
    return SettingsModel(
        geminiApiKey: geminiApiKey ?? this.geminiApiKey,
        modelName: modelName ?? this.modelName,
        isDarkMode: isDarkMode ?? this.isDarkMode,
        seedColorValue: seedColorValue ?? this.seedColorValue,
    );
  }

}