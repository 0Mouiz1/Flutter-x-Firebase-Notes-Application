import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class UpdateTaskScreen extends StatefulWidget {
  final DocumentSnapshot taskSnapshot;

  const UpdateTaskScreen({super.key, required this.taskSnapshot});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  TextEditingController taskC = TextEditingController();

  @override
  void initState() {
    taskC.text = widget.taskSnapshot['title'];
    super.initState();
  }

  @override
  void dispose() {
    taskC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(''),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                // MaterialPageRoute(builder: (context) => const DashboardScreen()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 250,
            ),
            Container(
              alignment: Alignment.center,
              height: 60.0,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 500,
                textInputAction: TextInputAction.next,
                controller: taskC,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  //fontFamily: GoogleFonts.eagleLake,
                ),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.task,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    hintText: 'Update',
                    hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
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
                      .doc(widget.taskSnapshot['taskId']);

                  await taskRef.update({'title': taskTitle});
                  Fluttertoast.showToast(
                    msg: 'Updated',
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  );

                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
