import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes.dart';

// global settings singleton
import 'app_settings.dart';
// simple auth gate used as MaterialApp.home
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // load persisted settings before running the app
  await AppSettings.instance.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // listen to the singleton so that theme/font changes are propagated
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "SignSpeech App",
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
          ),
          // globally adjust text scale according to font size setting
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaleFactor: AppSettings.instance.fontSize / 16.0),
              child: child!,
            );
          },
          home: const AuthGate(),
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}

/// simple widget that selects the start page based on authentication state
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginPage();
    }
    return const HomePage();
  }
}
