
import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'router.dart';

class PizzamineApp extends StatelessWidget {
  const PizzamineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pizzamine',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}