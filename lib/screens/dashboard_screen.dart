
import 'package:Notes/screens/profile_screen.dart';
import 'package:Notes/screens/update_task_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'add_task_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CollectionReference? tasksRef;

  @override
  void initState() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    tasksRef = FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('tasks');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const AddTaskScreen();
          }));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const ProfileScreen();
                }));
              },
              icon: const Icon(Icons.person)),
          IconButton(
              color: Colors.white,
              onPressed: () {
                showDialog(
                    // barrierColor: Colors.green.shade900,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        title: const Text(
                          'Confirmation',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'Are you sure to Logout ?',
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'No',
                                style: TextStyle(color: Colors.white),
                              )),
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);

                                await FirebaseAuth.instance.signOut();

                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return const LoginScreen();
                                }));
                              },
                              child: const Text(
                                'yes',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: tasksRef?.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Icon(
                Icons.error_outline,
                size: 50,
                color: Color.fromARGB(255, 0, 0, 0),
              )
                  //textAlign: TextAlign.center,
                  );
            }

            var listOfTasks = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: listOfTasks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color.fromARGB(255, 0, 0, 0),
                      child: ListTile(
                        title: Text(
                          listOfTasks[index]['title'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          getHumanReadableDate(listOfTasks[index]['createdOn']),
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              Color.fromARGB(255, 0, 0, 0),
                                          title: const Text(
                                            'Confirmation',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          content: const Text(
                                            'Are you sure to delete ?',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                            TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();

                                                  await tasksRef!
                                                      .doc(listOfTasks[index]
                                                          ['taskId'])
                                                      .delete();
                                                  Fluttertoast.showToast(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      msg: 'Deleted');
                                                },
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.white,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return UpdateTaskScreen(
                                          taskSnapshot: listOfTasks[index]);
                                    }));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            );
          }
        },
      ),
    );
  }

  String getHumanReadableDate(int timestamp) {
    DateFormat dateFormat = DateFormat('dd-MMM-yy HH:mm');

    return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }
}
