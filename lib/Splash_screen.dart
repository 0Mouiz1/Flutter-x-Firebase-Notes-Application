import 'dart:async';
import 'package:Notes/screens/dashboard_screen.dart';
import 'package:Notes/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                FirebaseAuth.instance.currentUser != null &&
                    FirebaseAuth.instance.currentUser!.emailVerified
                    ? const DashboardScreen()
                    : const LoginScreen(),
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.black,
        body: Container(

        color: Colors.black,
        child:  Center(
          child:
               Image.asset(
             'assets/appstore.png',
            // width: 600.0,
            // height: 240.0,
            // fit: BoxFit.fill,
                     ),
            // Center(
            //   child: Text('By Wayfarer',
            //   style:TextStyle(
            //     color:Colors.white,
            //     fontSize:20,
            //   ),
            //
            //   ),


          ),),
    );
  }
}

