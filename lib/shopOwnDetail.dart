//import page
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miniproj/editShop.dart';
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

  double? lat1, lng1;
  double? lat2, lng2;
  CameraPosition? position;

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
            lat1 = double.parse(data["lat"]);
            lng1 = double.parse(data["lng"]);
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
              showMap(),
            ],
          ),
        ),
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [checkifUSerDelete(data), checkifUSer(data)],
          ),
        ),
      ],
    );
  }

  Container showMap() {
    if (lat1 != null) {
      LatLng latlng = LatLng(lat1!, lng1!);
      position = CameraPosition(
        target: latlng,
        zoom: 16.0,
      );
    }

    // lat2 = locationData.latitude;

    Marker userMarker() {
      return Marker(
        markerId: MarkerId('userMarker'),
        position: LatLng(14.036462698183556, 100.72544090489826),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: 'User'),
      );
    }

    Marker shopMarker() {
      return Marker(
        markerId: MarkerId('shopMarker'),
        position: LatLng(lat1!, lng1!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Shop'),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[shopMarker()].toSet();
    }

    return Container(
        margin: EdgeInsets.all(10.0),
        color: Colors.grey,
        height: 250,
        child: lat1 == null
            ? showProgress()
            : GoogleMap(
                mapType: MapType.normal,
                onMapCreated: (controller) {},
                markers: mySet(),
                myLocationEnabled: true,
                initialCameraPosition:
                    CameraPosition(target: LatLng(lat1!, lng1!), zoom: 16)));
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  checkifUSer(data) {
    if (auth.currentUser?.email == data['owner']) {
      return showEditShop();
    }
    return Text('');
  }

  checkifUSerDelete(data) {
    if (auth.currentUser?.email == data['owner']) {
      return showDeleteShop();
    }
    return Text('');
  }

  Widget showEditShop() {
    return ElevatedButton.icon(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
      ),
      onPressed: () {
        /////navigator
        // getLocation();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => editShopPage(
                  docShopID: widget.listID[widget.todo].toString())),
        );
        //widget.listID[widget.todo]
      },
      icon: Icon(Icons.edit), //icon data for elevated button
      label: Text(
        "แก้ไขร้านค้า",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(_position);

    return _position;
  }

  Widget showDeleteShop() {
    return ElevatedButton.icon(
      onPressed: () {
        delete();
        getLocation();
        Navigator.pushNamed(context, '/foodlist');
      },
      icon: Icon(Icons.delete), //icon data for elevated button
      label: Text(
        "ลบร้านค้า",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Future<void> delete() async {
    var del = db.collection('shops').doc(widget.listID[widget.todo]);
    // await _db.collection("notes").doc("note1").delete();
    final docUser = FirebaseFirestore.instance
        .collection('shops')
        .doc(widget.listID[widget.todo]);
    docUser.delete();
  }
}
