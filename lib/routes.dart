import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/instructions_page.dart';
import 'pages/edit_profile_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case '/instructions':
        return MaterialPageRoute(builder: (_) => const InstructionsPage());
      case '/edit-profile':
        return MaterialPageRoute(builder: (_) => const EditProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
