// lib/core/presentation/providers/language_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing current app language
/// Controls which content language to fetch (EN or UR)
final languageProvider = StateNotifierProvider<LanguageController, LanguageState>(
  (ref) => LanguageController(),
);

class LanguageController extends StateNotifier<LanguageState> {
  LanguageController() : super(LanguageState(currentLanguage: 'en'));

  /// Switch to English
  void switchToEnglish() {
    state = LanguageState(currentLanguage: 'en');
  }

  /// Switch to Urdu
  void switchToUrdu() {
    state = LanguageState(currentLanguage: 'ur');
  }

  /// Toggle between EN and UR
  void toggleLanguage() {
    state = LanguageState(
      currentLanguage: state.currentLanguage == 'en' ? 'ur' : 'en',
    );
  }

  /// Set specific language
  void setLanguage(String languageCode) {
    if (languageCode == 'en' || languageCode == 'ur') {
      state = LanguageState(currentLanguage: languageCode);
    }
  }
}

// ============================================
// STATE CLASS
// ============================================

class LanguageState {
  final String currentLanguage;

  LanguageState({required this.currentLanguage});

  bool get isEnglish => currentLanguage == 'en';
  bool get isUrdu => currentLanguage == 'ur';

  String get languageName => currentLanguage == 'en' ? 'English' : 'اردو';
  String get languageCode => currentLanguage;
}