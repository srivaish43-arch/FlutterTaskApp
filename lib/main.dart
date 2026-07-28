import 'package:flutter/material.dart';
import 'view/splash_view.dart';

void main() {
  runApp(const TaskManagerApplication());
}

class TaskManagerApplication extends StatelessWidget {
  const TaskManagerApplication({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 74, 9, 86),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 74, 9, 86),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: SplashView(),
    );
  }
}
