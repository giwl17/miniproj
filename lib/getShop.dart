import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class getShopName extends StatelessWidget {
  final String documentID;

  getShopName({required this.documentID});

  CollectionReference shops = FirebaseFirestore.instance.collection('shops');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: shops.doc(documentID).get(),  
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text('${data['name']}');
          }
          return Text('Loading...');
        }));
  }
}

class getShopPicture extends StatelessWidget {
  final String documentID;

  getShopPicture({required this.documentID});

  CollectionReference shops = FirebaseFirestore.instance.collection('shops');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: shops.doc(documentID).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Image.network(
              data['picture'],
              fit: BoxFit.fill,
              width: 100,
              height: 200,
            );
          }
          return Text('Loading...');
        }));
  }
}
