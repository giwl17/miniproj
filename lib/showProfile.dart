import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miniproj/editProfile.dart';
import 'package:miniproj/foodlist.dart';
import 'package:miniproj/main.dart';

// class ShowProfilePage extends StatelessWidget {
//   const ShowProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//       ),
//       home: const MyShowProfilePage(title: 'โปรไฟล์'),
//       routes: {
//         '/editprofile': (context) => EditProfilePage(),
//         '/foodlist': (context) => FoodListPage(),
//       },
//     );
//   }
// }

class MyShowProfilePage extends StatefulWidget {
  const MyShowProfilePage({super.key, required this.title});

  final String title;

  @override
  State<MyShowProfilePage> createState() => _MyShowProfilePageState();
}

class _MyShowProfilePageState extends State<MyShowProfilePage> {
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

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
        title: Text(widget.title),
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
                  'แก้ไข',
                  style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      color: Colors.blue),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/editprofile');
                  // Navigator.pushNamed(context, '/edit');
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/6.png'),
                ),
              ),
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
                style: TextStyle(fontSize: 20.0),
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
                style: TextStyle(fontSize: 20.0),
              )),
            ),
          ),
        ],
      ),
    );
  }
}