import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/services/core/navigation_service.dart';
import 'package:tictactoe/views/controller_bindings.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBindings(),
      getPages: NavigationService.pages,
      theme: ThemeData.dark(),
    );
  }
}
