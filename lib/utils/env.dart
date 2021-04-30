import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

final Map<String, String> env = {};

Future<void> loadEnv() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    var fileString = await rootBundle.loadString('.env');
    if (fileString.isEmpty) {
      throw Exception('.env file is empty');
    }
    final lines = fileString.split('\n');
    for (final line in lines) {
      int index = line.indexOf("=");
      final key = line.substring(0, index).trim();
      final value = line.substring(index + 1).trim();
      env[key] = value;
    }
  } on FlutterError {
    throw Exception('Failed to parse .env');
  }
}

String get supabaseUrl => env['SUPABASE_URL'] ?? 'unavailable';
String get supabaseKey => env['SUPABASE_KEY'] ?? 'unavailable';
String get thunderforestKey => env['THUNDERFOREST_KEY'] ?? 'unavailable';
