import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/auth_controller.dart';
import 'auth/login_screen.dart';
import 'tasks/task_list_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

final themeInitializerProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isDarkMode') ?? false;
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      theme: isDarkMode ? darkTheme : lightTheme,
      home: authState.when(
        data: (user) {
          if (user == null) {
            return LoginScreen();
          } else {
            return TaskListScreen();
          }
        },
        loading: () =>
            Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) =>
            Scaffold(body: Center(child: Text("Error: $err"))),
      ),
    );
  }
}
