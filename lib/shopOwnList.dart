import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:miniproj/getShop.dart';
import 'package:miniproj/main.dart';
import 'package:miniproj/shopOwnDetail.dart';

class shopOwnListPage extends StatefulWidget {
  const shopOwnListPage({super.key});

  @override
  State<shopOwnListPage> createState() => _shopOwnListPageState();
}

class _shopOwnListPageState extends State<shopOwnListPage> {
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference shops =
      FirebaseFirestore.instance.collection('shops');

  List<String> shopDocList = [];
  List<String> shopDocListID = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ร้านค้าของคุณ',
          style: GoogleFonts.kanit(),
        ),
      ),
      body: FutureBuilder(
          future: getShopList(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: shopDocList.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        print(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShopOwnDetailPage(todo: index, listID: shopDocListID,),
                          ),
                        );
                      },
                      leading: getShopPicture(documentID: shopDocList[index]),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getShopName(documentID: shopDocList[index]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  Future getShopList() async {
    final shopsOwn = FirebaseFirestore.instance
        .collection('shops')
        .where('owner', isEqualTo: auth.currentUser?.email.toString());
    await shopsOwn.get().then(
          (snapshot) => snapshot.docs.forEach((element) {
            print(element.reference);
            print(element.reference.id);
            shopDocList.add(element.reference.id);
            shopDocListID.add(element.reference.id); //Document ID
          }),
        );
  }
}
