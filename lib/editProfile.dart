import 'package:flutter/material.dart';
import 'package:miniproj/showProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyEditProfile(),
      routes: {
        '/showprofile': (context) => const ShowProfilePage(),
      },
    );
  }
}

class MyEditProfile extends StatefulWidget {
  @override
  _MyEditProfileState createState() => _MyEditProfileState();
}

class _MyEditProfileState extends State<MyEditProfile> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();

  final auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
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
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      // color: Colors.red,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/6.png'),
                        ),
                      ),
                    ),
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
                                .catchError((error) =>
                                    print('Failed to update user: ${error}'));
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
}
