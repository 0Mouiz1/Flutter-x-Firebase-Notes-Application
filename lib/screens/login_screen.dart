import 'package:Notes/screens/sign_up_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'dashboard_screen.dart';
import 'email_verification.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailC, passC;

  @override
  void initState() {
    emailC = TextEditingController();
    passC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.center,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              SizedBox(
                height: 270,
              ),
              Container(
                alignment: Alignment.center,
                height: 60.0,
                child: TextField(
                  controller: emailC,
                  //
                  style: const TextStyle(
                    color: Colors.white,
                    //fontFamily: GoogleFonts.eagleLake,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    hintText: 'Enter your Email',
                    hintStyle: TextStyle(color: Colors.white30),
                  ),
                ),
              ),
              const Gap(16),
              Container(
                alignment: Alignment.center,
                height: 60.0,
                child: TextField(
                  obscureText: true,
                  controller: passC,
                  //
                  style: const TextStyle(
                    color: Colors.white,
                    //fontFamily: GoogleFonts.eagleLake,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.lock_open,
                      color: Colors.white,
                    ),
                    hintText: 'Enter your Password',
                    hintStyle: TextStyle(color: Colors.white30),
                  ),
                ),
              ),
              const Gap(16),
              ElevatedButton(
                //  style:ButtonStyle(
                //   backgroundColor:
                //  ),
                onPressed: () async {
                  FirebaseAuth auth = FirebaseAuth.instance;

                  try {
                    UserCredential userCredentials =
                        await auth.signInWithEmailAndPassword(
                            email: emailC.text.trim(),
                            password: passC.text.trim());

                    if (userCredentials.user!.emailVerified) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return const DashboardScreen();
                      }));
                    } else {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const EmailVerificationScreen();
                      }));
                    }
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.message!)));
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              const Gap(16),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const SignUpScreen();
                    }));
                  },
                  child: const Text(
                    'Not Registered Yet? Sign up',
                    style: TextStyle(color: Colors.white),
                  )),
              const Gap(16),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ForgotPasswordScreen();
                  }));
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
