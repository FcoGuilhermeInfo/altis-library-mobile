
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/app_header.dart';

void main() {
  runApp(const LokBooksApp());
}

class LokBooksApp extends StatelessWidget {
  const LokBooksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LokBooks',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(
        appBar: AppHeader(),
      ),
    );
  }
}
