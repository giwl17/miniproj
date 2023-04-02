import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproj/editProfile.dart';

class MyShowProfilePage extends StatefulWidget {
  const MyShowProfilePage({super.key, required this.title});

  final String title;
  @override
  State<MyShowProfilePage> createState() => _MyShowProfilePageState();
}

class _MyShowProfilePageState extends State<MyShowProfilePage> {
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final storageRef = FirebaseStorage.instance.ref();
  String email = FirebaseAuth.instance.currentUser?.email.toString() ?? '';
  // final imageUrl = getImageUrl(refTarget: 'a@a.com').toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/foodlist');
          },
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.kanit(),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: db
            .collection('users')
            .doc(auth.currentUser?.email.toString())
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text('Document does not exist');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return showProfile(data);
          }
          return const Text('loading');
        },
      ),
    );
  }

  Center showProfile(Map<String, dynamic> data) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                child: Text(
                  'แก้ไขโปรไฟล์',
                  style: GoogleFonts.kanit(
                    textStyle: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        color: Colors.blue),
                  ),
                ),
                onTap: () {
                  // Navigator.pushNamed(context, '/editprofile');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyEditProfile(
                        name: data['name'],
                        lastname: data['lastname'],
                        profile: data['profile'],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: CircleAvatar(
              radius: 90,
              backgroundImage: imageProfileShow(data),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              color: Colors.amber[600],
              child: Center(
                  child: Text(
                'ชื่อ: ${data['name']}',
                style: GoogleFonts.kanit(fontSize: 20),
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              color: Colors.amber[500],
              child: Center(
                  child: Text(
                'นามสกุล: ${data['lastname']}',
                style: GoogleFonts.kanit(fontSize: 20),
              )),
            ),
          ),
        ],
      ),
    );
  }

  static Future<String?> getImageUrl({required String refTarget}) async {
    try {
      final url =
          await FirebaseStorage.instance.ref(refTarget).getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print('$e');
      return null;
    }
  }

  NetworkImage imageProfileShow(Map<String, dynamic> data) {
    if (data['profile'] == '') {
      // return AssetImage('assets/6.png');
      return NetworkImage(
          'https://cdn.icon-icons.com/icons2/1141/PNG/512/1486395884-account_80606.png');
    } else {
      //return FileImage(File(data['profile']));
      //return Image.network(data['profile']);
      return NetworkImage(data['profile']);
    }
  }
}
