// ignore: depend_on_referenced_packages
import 'package:Notes/screens/dashboard_screen.dart';
import 'package:Notes/screens/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'Splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDXDqULdRr4pu1rrmyzlevw0sWPzd6kaXo',
          appId: '1:28483954587:android:2a903f359050359a21233e',
          messagingSenderId: '28483954587',
          projectId: 'wardy-one',
          storageBucket: 'wardy-one.appspot.com'));

  runApp(const MyApp());

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 0, 0), // Set the color here
          // You can also customize other properties of the app bar here
          // For example, textTheme, iconTheme, etc.
        ),
        useMaterial3: true,
      ),
      home:MyHomePage(),
    );
  }
}
