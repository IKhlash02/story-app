import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddMapProvider extends ChangeNotifier {
  LatLng? alamatStory;
  String street = "";

  void setAlamatStory(LatLng latLng) {
    alamatStory = latLng;
  }

  void setStreet(String alamat) {
    street = alamat;
  }

  void setNull() {
    alamatStory = null;
    street = "";
  }
}
