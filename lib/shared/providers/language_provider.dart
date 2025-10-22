// lib/core/providers/language_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/constants/storage_keys.dart';

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super(AppConstants.english); // Default to English

  void setLanguage(String languageCode) {
    state = languageCode;
  }

  void toggleLanguage() {
    state =
        state == AppConstants.english
            ? AppConstants.urdu
            : AppConstants.english;
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>(
  (ref) => LanguageNotifier(),
);
