//import page
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproj/getShop.dart';
//import liabraly
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ShopOwnDetailPage extends StatefulWidget {
  ShopOwnDetailPage({super.key, required this.todo, required this.listID});

  final todo;
  final List<String> listID;

  @override
  State<ShopOwnDetailPage> createState() => _ShopOwnDetailPageState();
}

class _ShopOwnDetailPageState extends State<ShopOwnDetailPage> {
  final auth = FirebaseAuth.instance;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final CollectionReference shops =
      FirebaseFirestore.instance.collection('shops');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียดร้านค้า',
          style: GoogleFonts.kanit(),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: db.collection('shops').doc(widget.listID[widget.todo]).get(),
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
            return shopDetailPage(data);
          }
          return const Text('loading');
        },
      ),
    );
  }

  Widget shopDetailPage(data) {
    return ListView(
      children: <Widget>[
        Container(
          height: 250,
          child: Image.network(data['picture'], fit: BoxFit.fill),
        ),
        Container(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.black26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['name'],
                      style: GoogleFonts.kanit(fontSize: 48),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ข้อมูลร้านค้า",
                          style: GoogleFonts.kanit(fontSize: 24),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "เวลาเปิด-ปิดร้าน: ${data['time']}",
                                    style: GoogleFonts.kanit(fontSize: 18),
                                  ),
                                  Text(
                                    "เบอร์โทร: ${data['tel']}",
                                    style: GoogleFonts.kanit(fontSize: 18),
                                  ),
                                  Text(
                                    "ที่อยู่: ${data['adddress']}",
                                    style: GoogleFonts.kanit(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: ListTile(
                  title: Text("Location"),
                ),
              ),
            ],
          ),
        ),
        Center(
          heightFactor: 2.5,
          child: ElevatedButton(
            onPressed: () {},
            child: Text("แก้ไขร้านค้า"),
          ),
        ),
      ],
    );
  }
}
