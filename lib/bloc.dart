import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class ProviderMaps with ChangeNotifier {
  // bool Check = false;
  late LatLng _gpsactual;
  LatLng _initialposition = LatLng(14.036462698183556, 100.72544090489826);
  bool activegps = true;
  TextEditingController locationController = TextEditingController();
  late GoogleMapController _mapController;
  LatLng get gpsPosition => _gpsactual;
  LatLng get initialPos => _initialposition;
  final Set<Marker> _markers = Set();
  Set<Marker> get markers => _markers;
  GoogleMapController get mapController => _mapController;

  void getMoveCamera() async {
    // List<Placemark> newPlace = await GeocodingPlatform.instance
    //     .placemarkFromCoordinates(
    //         _initialposition.latitude, _initialposition.longitude,
    //         localeIdentifier: "en_TH");

    List<Placemark> placemark = await placemarkFromCoordinates(
        _initialposition.latitude, _initialposition.longitude,
        localeIdentifier: "en_TH");
    locationController.text = placemark[0].name!;
  }

  void getUserLocation() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      activegps = false;
    } else {
      activegps = true;
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: "th_TH");
      _initialposition = LatLng(position.latitude, position.longitude);
      print(
          "the latitude is: ${position.latitude} and th longitude is: ${position.longitude} ");
      for (int a = 0; a < placemark.length; a++) {
        print(Geolocator.getCurrentPosition);
        // print(placemark[a]);
      }
      locationController.text = placemark[0].name!;
      _addMarker(_initialposition, placemark[0].name!);
      _mapController.moveCamera(CameraUpdate.newLatLng(_initialposition));
      print("initial position is : ${placemark[0].name}");
      notifyListeners();
    }
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) async {
    print(position.target);
    _initialposition = position.target;
    notifyListeners();
  }
}
