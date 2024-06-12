import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'dashboard_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? timer;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  void checkEmailVerified() {
    FirebaseAuth.instance.currentUser!.reload();

    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      timer?.cancel();

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const DashboardScreen();
      }));
    } else {}
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Email Verification'),
        // ),
        body: ListView(
      children: [
        const SizedBox(
          height: 250,
        ),
        const Text(
          'An Email has been sent to your account\nPlease verify your email',
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const Gap(40),
        const Center(
          child: CircularProgressIndicator(
            //backgroundColor: Color.fromARGB(255, 231, 129, 19),
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const Gap(20),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Color.fromARGB(255, 0, 0, 0))),
            onPressed: () {
              FirebaseAuth.instance.currentUser!.sendEmailVerification();
            },
            child: const Text(
              'Resend Email',
              style: TextStyle(
                color: Colors.white,
              ),
            ))
      ],
    ));
  }
}
