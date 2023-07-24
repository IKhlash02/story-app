import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../widget/place_mark_widget.dart';

class PickerPage extends StatefulWidget {
  final Function() onPickMap;
  const PickerPage({
    Key? key,
    required this.onPickMap,
  }) : super(key: key);

  @override
  State<PickerPage> createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  LatLng locationDefault = const LatLng(-0.942942, 100.371857);
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: locationDefault,
              ),
              myLocationEnabled: true,
              markers: markers,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: (controller) async {
                final info = await geo.placemarkFromCoordinates(
                    locationDefault.latitude, locationDefault.longitude);

                final place = info[0];
                final street = place.street!;
                final address =
                    '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                setState(() {
                  placemark = place;
                  mapController = controller;
                });

                defineMarker(locationDefault, street, address);
              },
              onLongPress: (LatLng latLng) {
                onLongPressGoogleMap(latLng);
              },
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                child: const Icon(Icons.my_location),
                onPressed: () {
                  onMyLocationButtonPress();
                },
              ),
            ),
            if (placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: PlacemarkWidget(
                  detail: false,
                  onPickMap: () => widget.onPickMap(),
                  latLng: locationDefault,
                  placemark: placemark!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
      locationDefault = latLng;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool servicedEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    servicedEnabled = await location.serviceEnabled();
    if (!servicedEnabled) {
      servicedEnabled = await location.requestService();
      if (!servicedEnabled) {
        debugPrint("Location services is not available");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        debugPrint("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
      locationDefault = latLng;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    setState(() {
      markers.cast();
      markers.add(marker);
    });
  }
}
