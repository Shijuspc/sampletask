import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier(bool isDark) : super(isDark);

  Future<void> toggleTheme(bool isDark) async {
    state = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  throw UnimplementedError();
});
