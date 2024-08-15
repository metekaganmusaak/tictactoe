import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tictactoe/app.dart';
import 'package:tictactoe/services/remote/auth_service.dart';
import 'package:tictactoe/services/remote/database_service.dart';

Future<void> main() async {
  /// If we want to call async function before [runApp] we need to call
  /// [WidgetsFlutterBinding.ensureInitialized] first.
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize();
  runApp(const App());
}

Future<void> _initialize() async {
  /// Initialize dotenv for environment variables.
  await dotenv.load(fileName: ".env");

  /// Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 5,
      timeout: Duration(seconds: 30),
    ),
  );

  /// Initialize AuthService
  await Get.putAsync(() async => await AuthService().init());

  /// Initialize DatabaseService
  Get.put(DatabaseService());
}
