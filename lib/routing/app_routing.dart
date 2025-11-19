import 'package:dailydo_app/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../themes/app_theme.dart';
import 'app_pages.dart';

class AppRouting extends StatefulWidget {
  const AppRouting({Key? key}) : super(key: key);

  @override
  State<AppRouting> createState() => _AppRoutingState();
}

class _AppRoutingState extends State<AppRouting> {
  late GoRouter _router;
  @override
  void initState() {
    super.initState();
    _router = buildRouter(context, AppPages.splashPath);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}