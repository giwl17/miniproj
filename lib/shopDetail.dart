import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(
        title: 'ชื่อร้าน',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isVisible = true;
  bool _isVisible1 = true;

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void showToast1() {
    setState(() {
      _isVisible1 = !_isVisible1;
    });
  }

  File? _shop = null;
  File? imageFile;

  onChooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        _shop = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // onChooseImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await ImagePicker().getImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );

  //   setState(() {
  //     if (pickedFile != null) {
  //       _shop = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    bool role = true;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Image.network(
              "https://cdn.w600.comps.canstockphoto.com/shop-market-icon-eps-vector_csp16356345.jpg"),
          Container(
            color: Colors.green,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'ชื่อร้าน',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.green,
                  child: ListTile(
                    title: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent),
                        onPressed: () {
                          showToast();
                        },
                        child: Text("ข้อมูลร้านค้า")),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                          visible: _isVisible,
                          child: Text("ข้าวอร่อยได้เยอะลองสั่งกันดูได้จ้า")),
                    ),
                  ],
                ),
                Container(
                  color: Colors.green,
                  child: ListTile(
                    title: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent),
                        onPressed: () {
                          showToast1();
                        },
                        child: Text("Location")),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                          visible: _isVisible1, child: Text("ร้านอยู่นี่นะ")),
                    ),
                  ],
                ),
              ],
            ),
          ),
          role == true
              ? Center(
                  heightFactor: 2.5,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("แก้ไขร้านค้า"),
                  ),
                )
              : Text(""),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
