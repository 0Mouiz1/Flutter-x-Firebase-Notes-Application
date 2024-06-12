
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController nameC, mobileC, emailC, passC, confirmC;
  String selectedGender = 'Male';

  @override
  void initState() {
    nameC = TextEditingController();
    mobileC = TextEditingController();
    emailC = TextEditingController();
    passC = TextEditingController();
    confirmC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    mobileC.dispose();
    emailC.dispose();
    passC.dispose();
    confirmC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Sign Up'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60.0,
              child: TextField(
                controller: nameC,
                //
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  //fontFamily: GoogleFonts.eagleLake,
                ),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.person_2_sharp,
                      color: Color.fromARGB(255, 8, 8, 8),
                    ),
                    hintText: 'Enter your Name',
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),
            const Gap(16),
            Container(
              alignment: Alignment.center,
              height: 60.0,
              child: TextField(
                controller: mobileC,
                //
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  //fontFamily: GoogleFonts.eagleLake,
                ),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    hintText: 'Enter your Mobile Number',
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),
            const Gap(16),
            Container(
              alignment: Alignment.center,
              height: 60.0,
              child: TextField(
                controller: emailC,
                //
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  //fontFamily: GoogleFonts.eagleLake,
                ),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    hintText: 'Enter your Email',
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),
            const Gap(16),
            Container(
              alignment: Alignment.center,
              height: 60.0,
              child: TextField(
                controller: passC,
                //
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  //fontFamily: GoogleFonts.eagleLake,
                ),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    hintText: 'Enter your Password',
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),
            const Gap(16),
            Container(
              alignment: Alignment.center,
              height: 60.0,
              child: TextField(
                controller: confirmC,
                //
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  //fontFamily: GoogleFonts.eagleLake,
                ),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.recycling,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    hintText: 'Confirm your password',
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),
            const Gap(16),
            CupertinoSegmentedControl(
                borderColor: Color.fromARGB(255, 0, 0, 0),
                groupValue: selectedGender,
                selectedColor: Color.fromARGB(255, 0, 0, 0),
                children: const {
                  'Male': Text('Male'),
                  'Female': Text('Female'),
                  'Other': Text('Other')
                },
                onValueChanged: (newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                }),
            const Gap(16),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(Color.fromARGB(255, 0, 0, 0))),
              onPressed: () async {
                String name = nameC.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please provide name')));
                  return;
                }

                String mobile = mobileC.text.trim();
                String email = emailC.text.trim();
                String pass = passC.text.trim();
                String confirmPass = confirmC.text.trim();

                if (pass != confirmPass) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords must match')));
                  return;
                }

                // if everything is OK

                FirebaseAuth auth = FirebaseAuth.instance;

                try {
                  UserCredential userCredential =
                      await auth.createUserWithEmailAndPassword(
                          email: email, password: pass);

                  if (userCredential.user != null) {
                    // Now store other info to database
                    String uid = userCredential.user!.uid;

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .set({
                      'uid': uid,
                      'name': name,
                      'mobile': mobile,
                      'email': email,
                      'gender': selectedGender,
                      'photo': null,
                      'createdOn':
                          DateTime.now().millisecondsSinceEpoch, // timestamp
                    });

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account Created'),
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      ),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.message!),
                    backgroundColor: Colors.green.shade400,
                  ));
                }
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Gap(16),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Already Registered? Login',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold
                      //fontFamily: GoogleFonts.eagleLake,
                      ),
                )),
          ],
        ),
      ),
    );
  }
}
