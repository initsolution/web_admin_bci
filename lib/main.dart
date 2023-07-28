import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/environment.dart';
import 'package:flutter_web_ptb/root_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Environment.init(
    apiBaseUrl: 'https://example.com',
  );

  runApp(const ProviderScope(child: RootApp()));
}
