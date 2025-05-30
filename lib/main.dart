import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/home.dart';
import 'package:todo/provider/theme/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //Ensure widget is initialized 👍
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Watch ThemeMode
    final themeMode = ref.watch(themeNotifierProvider);

    //Use DynamicColorBuilder to get theme dynamically
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          theme: ThemeData(
            colorScheme:
                lightDynamic ??
                ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                ), //Fallback if dynamic theme is not supported
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme:
                darkDynamic ??
                ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                ), //Fallback if dynamic theme is not supported
            useMaterial3: true,
          ),
          themeMode: themeMode,
          home: HomeScreen(),
        );
      },
    );
  }
}
