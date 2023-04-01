import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miniproj/Gmap_page.dart';

class addShopPage extends StatefulWidget {
  @override
  _addShopPageState createState() => _addShopPageState();
}

class _addShopPageState extends State<addShopPage> {
  final _formstate = GlobalKey<FormState>();
  TextEditingController shopname = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController address = TextEditingController();

  File? _shop = null;
  File? imageFile;
  String? _imageUrl;

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

  final auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  LatLng? text;
  @override
  void initState() {
    shopname.text = ""; //innitail value of text field
    time.text = "";
    tel.text = ""; //innitail value of text field
    address.text = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final provmaps = Provider.of<ProviderMaps>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "เพิ่มร้านของคุณ",
            style: GoogleFonts.kanit(),
          ),
          backgroundColor: Colors.red,
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'ร้านค้าของคุณ',
                    style:
                        GoogleFonts.kanit(textStyle: TextStyle(fontSize: 42)),
                  ),
                  Form(
                    key: _formstate,
                    child: Column(
                      children: [
                        Container(height: 20),
                        buildTextFfield_ShopName(),
                        Container(height: 10),
                        buildTextInfoShop(),
                        Container(height: 10),
                        buildTextFfield_Time(),
                        Container(height: 15),
                        buildTextFfield_Tel(),
                        Container(height: 15),
                        buildTextFfield_Address(),
                        Container(height: 15),
                        buildTextAddPicture(),
                        Container(height: 10),
                      ],
                    ),
                  ),
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
                                  style: GoogleFonts.kanit(),
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

                                _awaitReturnValueFromSecondScreen(context);
                              },
                              child: Text(
                                "Choose location",
                                style: GoogleFonts.kanit(
                                    textStyle: TextStyle(fontSize: 16)),
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
                      text == ''
                          ? Text(
                              'Latlong',
                              style: GoogleFonts.kanit(
                                textStyle: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                              ),
                            )
                          : Text(text.toString())
                    ],
                  ),
                  Container(height: 10),
                  ButtonAddShop()
                ],
              ),
            ),
          ],
        ));
  }

  Container ButtonAddShop() {
    return Container(
      // height: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 50,
          width: 200,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
            ),
            onPressed: () {
              addShop();
            },
            child: Text(
              "ยืนยันการเพิ่มร้าน",
              style: GoogleFonts.kanit(
                  textStyle: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ),
        ),
      ),
    );
  }

  Row buildTextAddPicture() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "เพิ่มรูปภาพ",
          style: GoogleFonts.kanit(textStyle: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }

  TextFormField buildTextFfield_Address() {
    return TextFormField(
      style: GoogleFonts.kanit(textStyle: TextStyle(fontSize: 18)),
      controller: address,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_box),
        labelText: "ที่อยู่",
        border: myinputborder(),
      ),
      validator: (value) {
        if (value == '') {
          return 'โปรดกรอกที่อยู่';
        }
      },
    );
  }

  TextFormField buildTextFfield_Tel() {
    return TextFormField(
      style: GoogleFonts.kanit(textStyle: TextStyle(fontSize: 18)),
      controller: tel,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_call),
        labelText: "เบอร์โทร",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      validator: (value) {
        if (value == '') {
          return 'โปรดกรอกเบอร์โทร';
        }
      },
    );
  }

  TextFormField buildTextFfield_Time() {
    return TextFormField(
      style: GoogleFonts.kanit(textStyle: TextStyle(fontSize: 18)),
      controller: time,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.timer),
          labelText: "เวลาทำการ",
          border: myinputborder(),
          hintText: '9.00-18.00'),
      validator: (value) {
        if (value == '') {
          return 'โปรดกรอกเวลาทำการ';
        }
      },
    );
  }

  Row buildTextInfoShop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'ข้อมูลร้านค้า',
          style: GoogleFonts.kanit(textStyle: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }

  TextFormField buildTextFfield_ShopName() {
    return TextFormField(
      controller: shopname,
      style: GoogleFonts.kanit(textStyle: TextStyle(fontSize: 18)),
      decoration: InputDecoration(
        labelText: "ชื่อ ร้านของคุณ",
        prefixIcon: Icon(Icons.people),
        border: myinputborder(),
      ),
      validator: (value) {
        if (value == '') {
          return 'โปรกรอกชื่อร้านของคุณ';
        }
      },
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 3,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(
          color: Colors.greenAccent,
          width: 3,
        ));
  }

  //create a function like this so that you can use it wherever you want

  addShop() {
    final emailCurrentUser = auth.currentUser?.email;
    String? _imgUrl;

    if (_formstate.currentState!.validate()) {
      _formstate.currentState!.save();
      print(shopname.text);
      print(time.text);
      print(tel.text);
      print(address.text);
      print(text!.latitude);
      uploadImageProfile().then((value) {
        _imgUrl = value;
        Map<String, String> data = {
          'name': shopname.text.trim(),
          'time': time.text.trim(),
          'tel': tel.text.trim(),
          'adddress': address.text.trim(),
          'owner': emailCurrentUser.toString(),
          'picture': _imgUrl.toString(),
          'lat': text!.latitude.toString(),
          'lng': text!.longitude.toString(),
        };
        db.collection('shops').add(data).then(
              (documentSnapshot) =>
                  print("added data with ID ${documentSnapshot.id}"),
            );
      });
    }
  }

  Future<String> uploadImageProfile() async {
    //Stroage Image Upload
    Reference ref = FirebaseStorage.instance.ref().child('${shopname}}.jpg');
    await ref.putFile(File(_shop!.path));
    final imgUrl = await ref.getDownloadURL().then((value) {
      print('value : ${value}');
      _imageUrl = value;
      print('imageUrl${_imageUrl}');
      return value;
    });
    print('imgUrl: ${imgUrl}');
    return imgUrl;
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Gmap(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      text = result;
    });
  }
}
