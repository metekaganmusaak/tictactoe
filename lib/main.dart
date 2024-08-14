import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tictactoe/app.dart';
import 'package:tictactoe/services/remote/auth_service.dart';
import 'package:tictactoe/services/remote/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize();

  runApp(const App());
}

_initialize() async {
  await Supabase.initialize(
    url: 'https://hoivjfuhdgsvcokalgyg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhvaXZqZnVoZGdzdmNva2FsZ3lnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM1NTIzMTYsImV4cCI6MjAzOTEyODMxNn0.sp67gSQzemTHRXuuJfIkaLA_WZT1uxCbOcZGn5QAARg',
    realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 2),
  );

  await Get.putAsync(() async => await AuthService().init());

  Get.put(DatabaseService());
}
