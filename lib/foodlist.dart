import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miniproj/addShop.dart';
import 'package:miniproj/editProfile.dart';
import 'package:miniproj/editShop.dart';
import 'package:miniproj/forgetpass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproj/getShop.dart';
import 'package:miniproj/login.dart';
import 'package:miniproj/main.dart';
import 'package:miniproj/register.dart';
import 'package:miniproj/searchPage.dart';
import 'package:miniproj/shopOwnDetail.dart';
import 'package:miniproj/shopOwnList.dart';
import 'package:miniproj/showProfile.dart';

class FoodListPage extends StatelessWidget {
  const FoodListPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const myPage(title: 'แมวเป้า'),
      routes: {
        '/login': (context) => const LoginPage(title: 'เข้าสู่ระบบ'),
        '/register': (context) => const RegisterPage(),
        '/forget': (context) => const ForgetPassPage(),
        '/foodlist': (context) => const FoodListPage(),
        '/showprofile': (context) => const MyShowProfilePage(title: 'โปรไฟล์'),
        // '/editprofile': (context) => MyEditProfile(),
        '/addshop': (context) => addShopPage(),
        //'/editshop': (context) => editShopPage(),
        '/ownshop': (context) => const shopOwnListPage(),
        '/search': (context) => Search(),
      },
    );
  }
}

class myPage extends StatefulWidget {
  const myPage({super.key, required this.title});

  final String title;

  @override
  State<myPage> createState() => _myPageState();
}

class _myPageState extends State<myPage> {
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final users = FirebaseFirestore.instance.collection('users');

  List<String> shopDocList = [];
  List<String> shopDocListID = [];

  @override
  Widget build(BuildContext context) {
    final users = db.collection('users').get();
    List<String> list = [
      "assets/1.png",
      "assets/2.png",
      "assets/3.png",
      "assets/4.png",
      "assets/5.png"
    ];
    return futureBuilder(list);
  }

  FutureBuilder<DocumentSnapshot<Object?>> futureBuilder(List<String> list) {
    return FutureBuilder<DocumentSnapshot>(
      future: db.collection('users').doc(auth.currentUser?.email).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        print(auth.currentUser?.email);
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text('Document does not exist');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                widget.title,
                style: GoogleFonts.kanit(),
              ),
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.all(9),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/search');
                              },
                              child: Container(
                                width: 350,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.teal,
                                      Colors.teal,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(36),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(5, 5),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'กดที่นี่ เพื่อค้นหาร้านค้า',
                                    style: GoogleFonts.kanit(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: CarouselSlider(
                          options: CarouselOptions(),
                          items: list
                              .map((item) => Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                          child: Image(
                                              image:
                                                  AssetImage(item.toString()))),
                                    ),
                                    color: Colors.white,
                                  ))
                              .toList(),
                        ),
                      ),
                      shopListDisplay(),
                    ],
                  ),
                ),
              ),
            ),
            endDrawer: Drawer(
              child: Container(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text('${data['name']} ${data['lastname']}'),
                      accountEmail: Text(auth.currentUser?.email ?? 'unknow'),
                      currentAccountPicture: ClipOval(
                        child: CircleAvatar(
                          radius: 90,
                          backgroundImage: imageProfileShow(data),
                        ),
                      ),
                      decoration: const BoxDecoration(color: Colors.red
                          // image: DecorationImage(
                          //   image: AssetImage("assets/1.png"),
                          //   fit: BoxFit.fill,
                          // ),
                          ),
                    ),
                    ListTile(
                      title: Text("โปรไฟล์"),
                      leading: Icon(Icons.person),
                      onTap: () {
                        Navigator.pushNamed(context, '/showprofile');
                      },
                    ),
                    ListTile(
                      title: Text("ร้านค้าของคุณ"),
                      leading: Icon(Icons.shopping_bag_outlined),
                      onTap: () {
                        Navigator.pushNamed(context, '/ownshop');
                      },
                    ),
                    ListTile(
                      title: Text("เพิ่มร้านค้า"),
                      leading: Icon(Icons.shopping_bag_outlined),
                      onTap: () {
                        Navigator.pushNamed(context, '/addshop');
                      },
                    ),
                    ListTile(
                      title: Text("ออกจากระบบ"),
                      leading: Icon(Icons.logout),
                      onTap: () {
                        auth.signOut();
                        Navigator.popAndPushNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Text('');
      }, //end FutureBuilder builduer:
    );
  }

  FutureBuilder<dynamic> shopListDisplay() {
    return FutureBuilder(
        future: getShopList(),
        builder: (context, snapshot) {
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
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
                            builder: (context) => ShopOwnDetailPage(
                              todo: index,
                              listID: shopDocListID,
                            ),
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
            ),
          );
        });
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

  Future getShopList() async {
    final shopsOwn = FirebaseFirestore.instance.collection('shops');
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
