import 'package:dailydo_app/screens/add_task_screen.dart';
import 'package:dailydo_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import 'app_pages.dart';

GoRouter buildRouter(BuildContext context, String initialRoute) {
  final router = GoRouter(
    initialLocation: initialRoute,
    debugLogDiagnostics: true,
    routes: [

      GoRoute(
        path: AppPages.splashPath,
        name: AppPages.splashPath,
        builder: (context, state) {
          return SplashScreen();
        },
      ),
      GoRoute(
        path: AppPages.homescreen,
        name: AppPages.homescreen,
        builder: (context, state) {
          return HomeScreen();
        },
      ),
      GoRoute(
        path: AppPages.addtaskscreen,
        name: AppPages.addtaskscreen,
        builder: (context, state) {
          return AddTaskScreen();
        },
      ),


    ],
  );
  return router;
}
