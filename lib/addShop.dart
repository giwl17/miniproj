import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
// import 'package:dadas/bloc.dart';
// import 'package:dadas/Gmap_page.dart';
// import 'package:dadas/test.dart';
// import 'package:dadas/map.dart';
import 'package:provider/provider.dart';

class addShopPage extends StatefulWidget {
  @override
  _addShopPageState createState() => _addShopPageState();
}

class _addShopPageState extends State<addShopPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController a = TextEditingController();
  TextEditingController c = TextEditingController();

  File? _shop = null;
  File? imageFile;

  onChooseImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
        source: ImageSource.camera, maxWidth: 200, maxHeight: 200);

    setState(() {
      if (pickedFile != null) {
        _shop = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    username.text = ""; //innitail value of text field
    password.text = "";
    a.text = ""; //innitail value of text field
    c.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final provmaps = Provider.of<ProviderMaps>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, '/');
            },
          ),
          title: Text("เพิ่มร้านของคุณ"),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'ร้านค้าของคุณ',
                    style: TextStyle(color: Colors.black, fontSize: 40),
                  ),
                  Container(height: 20),
                  TextField(
                      controller: username,
                      decoration: InputDecoration(
                        labelText: "ชื่อ ร้านของคุณ",
                        prefixIcon: Icon(Icons.people),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      )),
                  Container(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'ข้อมูลร้านค้า',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                  Container(height: 10),
                  TextField(
                      controller: password,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.timer),
                        labelText: "เวลาทำการ",
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      )),
                  Container(height: 15),
                  TextField(
                      controller: a,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add_call),
                        labelText: "เบอร์โทร",
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      )),
                  Container(height: 15),
                  TextField(
                      controller: c,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add_box),
                        labelText: "ที่อยู่",
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      )),
                  Container(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "เพิ่มรูปภาพ",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                  Container(height: 10),
                  _shop == null
                      ? ElevatedButton(
                          onPressed: () {
                            onChooseImage();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(120),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "+ เพิ่มรูปภาพ",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Image.file(_shop!),
                  Container(height: 15),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 200,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.green),
                              ),
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => MapsPage()),
                                // );
                              },
                              child: Text(
                                "Choose location",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Latlong',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                  Container(height: 10),
                  Container(
                    // height: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.green),
                          ),
                          onPressed: () {},
                          child: Text(
                            "ยืนยันการเพิ่มร้าน",
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
