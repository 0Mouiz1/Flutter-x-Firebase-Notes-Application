// import 'package:flutter/material.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Forgot Password'),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                )),
          ),
          IconTheme(
            data: const IconThemeData(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //padding: const EdgeInsets.all(16.0),
                children: [
                  const SizedBox(
                    height: 250,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 60.0,
                    child: TextField(
                      controller: _emailController,
                      //
                      style: const TextStyle(
                        color: Colors.white,
                        //fontFamily: GoogleFonts.eagleLake,
                      ),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          hintText: 'Enter your Email',
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _sendPasswordResetEmail();
                    },
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                          color: Color.fromARGB(255, 1, 0, 0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      Fluttertoast.showToast(
        msg: 'Password reset email sent!',
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      );
      Navigator.pop(context); // Close the screen after email sent
    } catch (error) {
      print('Failed to send password reset email: $error');
      Fluttertoast.showToast(
        msg: 'Failed to send password reset email',
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      );
    }
  }
}
//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }
// }
