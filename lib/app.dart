import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/services/core/localization_service.dart';
import 'package:tictactoe/services/core/navigation_service.dart';
import 'package:tictactoe/services/core/theme_service.dart';
import 'package:tictactoe/views/controller_bindings.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      /// We initialized all of our view controllers here
      initialBinding: ControllerBindings(),
      getPages: NavigationService.pages,
      translations: LocalizationService(),
      locale: Locale(_languageCode),
      fallbackLocale: Locale(LocalizationService.supportedLanguageCodes.first),
      theme: ThemeService.theme,
    );
  }

  /// Get device's language code. If its null, get fallback language.
  String get _languageCode {
    return Get.deviceLocale?.languageCode ??
        LocalizationService.supportedLanguageCodes.first;
  }
}
