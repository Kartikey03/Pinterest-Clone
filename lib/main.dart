import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'services/network_service.dart';

/// Application entry point.
///
/// Initializes:
/// 1. Flutter bindings
/// 2. Environment variables (.env)
/// 3. Network service (Dio)
/// 4. Riverpod [ProviderScope]
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize services
  await NetworkService.instance.init();

  runApp(const ProviderScope(child: PinterestApp()));
}
