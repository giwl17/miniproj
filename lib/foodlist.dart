import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miniproj/forgetpass.dart';
import 'package:miniproj/main.dart';
import 'package:miniproj/register.dart';
import 'package:miniproj/showProfile.dart';

class FoodListPage extends StatelessWidget {
  const FoodListPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routes: {
      //   '/home': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
      // },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const myPage(title: 'แมวเป้ารีวิว'),
      routes: {
        '/login': (context) =>
            const MyHomePage(title: 'Flutter Demo Home Page'),
        '/register': (context) => const RegisterPage(),
        '/forget': (context) => const ForgetPassPage(),
        '/foodlist': (context) => const FoodListPage(),
        '/showprofile': (context) => const ShowProfilePage(),
      },
    );
  }
}

class myPage extends StatefulWidget {
  const myPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<myPage> createState() => _myPageState();
}

class _myPageState extends State<myPage> {
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            backgroundColor: Colors.red,
            appBar: AppBar(title: Text(widget.title)),
            body: Center(
              child: Container(
                padding: EdgeInsets.all(9),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Text('${data['name']} ${data['lastname']} ${data['email']}'),
                    Container(
                      padding: EdgeInsets.only(
                          top: 25, bottom: 10, left: 10, right: 10),
                      color: Colors.red,
                      child: SizedBox(
                        height: 300,
                        width: 350,
                        child: Column(
                          children: [
                            Container(
                              color: Colors.grey,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      width: 280,
                                      child: SizedBox(
                                        width: 50,
                                        child: TextField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'ค้นหา',
                                              filled: true,
                                              fillColor: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.search)),
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
                                                  image: AssetImage(
                                                      item.toString()))),
                                        ),
                                        color: Colors.grey,
                                      ))
                                  .toList(),
                            )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.amber,
                      child: SizedBox(
                        height: 75,
                        width: 10,
                        child: ListTile(
                          onTap: () {},
                          title: Text(
                              "ร้าน ข้าวมันไก่ผัดหมูพริกแกงไก่กรอบหมูสับผัดไข่ดาวหมูกระเทียมพริกแกงใส่ใบกระเพรา"),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.amber,
                      child: SizedBox(
                        height: 75,
                        width: 10,
                        child: ListTile(
                          onTap: () {},
                          title: Text(
                              "ร้าน ข้าวมันไก่ผัดหมูพริกแกงไก่กรอบหมูสับผัดไข่ดาวหมูกระเทียมพริกแกงใส่ใบกระเพรา"),
                        ),
                      ),
                    ),
                  ],
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
                          radius: 30.0,
                          child: Image.asset("assets/6.png"),
                          backgroundColor: Colors.transparent,
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
                      title: Text("ประวัติการรีวิว"),
                      leading: Icon(Icons.history),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("ร้านค้าของคุณ"),
                      leading: Icon(Icons.shopping_bag_outlined),
                      onTap: () {},
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
}
