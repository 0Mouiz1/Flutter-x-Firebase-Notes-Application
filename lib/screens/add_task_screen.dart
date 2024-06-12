import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController taskC = TextEditingController();

  @override
  void dispose() {
    taskC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        //title: const Text(''),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),

        //elevation: 10, // Adjust the elevation for the shadow effect
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.next,
              controller: taskC,
              style: const TextStyle(
                  color: Colors.black //fontFamily: GoogleFonts.eagleLake,
                  ),
              decoration: const InputDecoration(
                //labelStyle: TextStyle(color: Color.fromARGB(255, 231, 129, 19)),
                hintText: 'Note',
                //fillColor: Color.fromARGB(255, 231, 129, 19),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(Icons.note_add, color: Colors.black),
              ),
            ),
            const Gap(16),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(Color.fromARGB(255, 0, 0, 0)),
                ),
                onPressed: () async {
                  String taskTitle = taskC.text.trim();
                  String uid = FirebaseAuth.instance.currentUser!.uid;

                  var taskRef = FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(uid)
                      .collection('tasks')
                      .doc();

                  try {
                    await taskRef.set({
                      'title': taskTitle,
                      'createdOn': DateTime.now().millisecondsSinceEpoch,
                      'taskId': taskRef.id,
                    });

                    Fluttertoast.showToast(
                      msg: 'Saved',
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    );
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: e.toString(),
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
