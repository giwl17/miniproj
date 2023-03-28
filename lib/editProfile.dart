import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miniproj/showProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:miniproj/main.dart';

// class EditProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyEditProfile(),
//       routes: {
//         '/showprofile': (context) => const MyShowProfilePage(title: 'โปรไฟล์'),
//       },
//     );
//   }
// }

class MyEditProfile extends StatefulWidget {
  const MyEditProfile({super.key});

  @override
  _MyEditProfileState createState() => _MyEditProfileState();
}

class _MyEditProfileState extends State<MyEditProfile> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();

  final auth = FirebaseAuth.instance;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/showprofile');
            },
          ),
          title: Text("แก้ไขโปรไฟล์"),
          backgroundColor: Colors.red,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: imageProfile(),
                  ),
                  TextField(
                      controller: fname,
                      decoration: InputDecoration(
                        labelText: "ชื่อ",
                        prefixIcon: Icon(Icons.abc),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      )),
                  Container(height: 20),
                  TextField(
                      controller: lname,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.abc),
                        labelText: "นามสกุล",
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      )),
                  Container(height: 20),
                  Container(
                    // height: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 245, 168, 59)),
                          ),
                          onPressed: () {
                            final users = db
                                .collection('users')
                                .doc(auth.currentUser?.email);

                            users
                                .update({
                                  'name': fname.text.trim(),
                                  'lastname': lname.text.trim()
                                })
                                .then((value) => print('User updated'))
                                .catchError(
                                  (error) =>
                                      print('Failed to update user: ${error}'),
                                );

                            uploadImageProfile();
                            Navigator.popAndPushNamed(context, '/showprofile');
                          },
                          child: Text(
                            "ยืนยันการแก้ไข",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget imageProfile() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 90,
          backgroundImage: _imageFile == null
              ? AssetImage('assets/6.png')
              : FileImage(File(_imageFile!.path)) as ImageProvider,
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.red,
              size: 28,
            ),
          ),
        )
      ],
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 3,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.greenAccent,
          width: 3,
        ));
  }

  //create a function like this so that you can use it wherever you want
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            'Choose Profile Photo',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text('Camera'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                label: Text('Gallery'),
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 100);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  void uploadImageProfile() async {
    //Stroage Image Upload
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('${auth.currentUser?.email}-profile.jpg');
    await ref.putFile(File(_imageFile!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      imageUrl = value;
    });
  }
}
