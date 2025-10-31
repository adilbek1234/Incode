import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'courses_page.dart';
import 'course_detail_page.dart';
import 'profile.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inclusive Learn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/courses': (context) => const CoursesPage(),
        '/course': (context) => const CourseDetailPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
