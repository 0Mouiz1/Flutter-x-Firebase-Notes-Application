import 'dart:io';

//import 'package:Todo/screens/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import 'dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DocumentSnapshot? userSnapshot;

  File? chosenImage;
  bool showLocalImage = false;

  getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {});
  }

  selectImageFrom(ImageSource imageSource) async {
    XFile? xFile = await ImagePicker().pickImage(source: imageSource);

    if (xFile == null) return;

    chosenImage = File(xFile.path);

    setState(() {
      showLocalImage = true;
    });

    // upload image to storage

    FirebaseStorage storage = FirebaseStorage.instance;

    var fileName = userSnapshot!['email'] + '.png';

    UploadTask uploadTask = storage
        .ref()
        //.child('profile_images')
        .child(fileName)
        .putFile(chosenImage!, SettableMetadata(contentType: 'image/png'));

    TaskSnapshot snapshot = await uploadTask;

    String profileImageUrl = await snapshot.ref.getDownloadURL();
    // ignore: avoid_print
    print(profileImageUrl);

    // save its url in users collection

    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'photo': profileImageUrl});

    Fluttertoast.showToast(
      msg: 'Profile image uploaded',
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
    );
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: const Text(
          '',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          //selectionColor: Colors.white,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardScreen()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      body: userSnapshot != null
          ? Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0), // Border color
                          width: 9.0, // Border width
                        ),
                      ),
                      child: CircleAvatar(
                        radius:
                            80, // Set the radius to a circular Radius object
                        backgroundColor:
                            Colors.transparent, // Ensure transparent background
                        child: ClipOval(
                          child: SizedBox(
                            width:
                                160, // Double the horizontal radius to make it an oval
                            height: 160, // Adjust the vertical radius as needed
                            child: showLocalImage
                                ? Image.file(
                                    chosenImage!,
                                    fit: BoxFit
                                        .cover, // Adjust this property as needed
                                  )
                                : Image.network(
                                    userSnapshot!['photo'] ??
                                        'https://www.hksyu.edu/assets/staffs/default/default_staff.png',
                                    fit: BoxFit
                                        .cover, // Adjust this property as needed
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Color.fromARGB(255, 0, 0, 0),
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ),
                                  title: const Text(
                                    'Gallery',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    selectImageFrom(ImageSource.gallery);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  title: const Text(
                                    'Camera',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    selectImageFrom(ImageSource.camera);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.linked_camera,
                      size: 30,
                      color: Color.fromARGB(255, 211, 18, 79),
                    )),
                const Gap(16),
                Text(
                  userSnapshot!['name'],
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  userSnapshot!['gender'],
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  userSnapshot!['email'],
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  userSnapshot!['mobile'],
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
    );
  }
}
