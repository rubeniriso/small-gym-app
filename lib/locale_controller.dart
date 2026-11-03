import 'package:flutter/material.dart';

/// In-memory language choice. It lasts for the process only, same as theme.
enum AppLanguage { system, english, spanish }

class LocaleController extends ChangeNotifier {
  AppLanguage _language = AppLanguage.system;

  AppLanguage get language => _language;

  void setLanguage(AppLanguage language) {
    if (_language == language) {
      return;
    }
    _language = language;
    notifyListeners();
  }

  /// System follows the platform language when it is Spanish, and English
  /// for every other language. English and Spanish are explicit overrides.
  Locale resolve(Locale platform) {
    return switch (_language) {
      AppLanguage.english => const Locale('en'),
      AppLanguage.spanish => const Locale('es'),
      AppLanguage.system =>
        platform.languageCode.toLowerCase() == 'es'
            ? const Locale('es')
            : const Locale('en'),
    };
  }
}
