import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:story_app_1/data/model/story_element.dart';

import '../widget/place_mark_widget.dart';

class MapsPage extends StatefulWidget {
  final StoryElement storyElement;
  const MapsPage({
    Key? key,
    required this.storyElement,
  }) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  MapType selectedMapType = MapType.normal;
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  geo.Placemark? placemark;
  late LatLng storyLocation;

  @override
  void initState() {
    super.initState();
    storyLocation = LatLng(widget.storyElement.lat!, widget.storyElement.lon!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              mapType: selectedMapType,
              markers: markers,
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: storyLocation,
              ),
              onMapCreated: (controller) async {
                final info = await geo.placemarkFromCoordinates(
                    storyLocation.latitude, storyLocation.longitude);

                final place = info[0];
                final street = place.street!;
                final address =
                    '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                setState(() {
                  placemark = place;
                  mapController = controller;
                });

                defineMarker(storyLocation, street, address);
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            Positioned(
              bottom: 150,
              right: 16,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: "zoom-in",
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomIn(),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton.small(
                    heroTag: "zoom-out",
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomOut(),
                      );
                    },
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton.small(
                onPressed: null,
                child: PopupMenuButton<MapType>(
                  onSelected: (MapType item) {
                    setState(() {
                      selectedMapType = item;
                    });
                  },
                  offset: const Offset(0, 54),
                  icon: const Icon(Icons.layers_outlined),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MapType>>[
                    const PopupMenuItem<MapType>(
                      value: MapType.normal,
                      child: Text('Normal'),
                    ),
                    const PopupMenuItem<MapType>(
                      value: MapType.satellite,
                      child: Text('Satellite'),
                    ),
                    const PopupMenuItem<MapType>(
                      value: MapType.terrain,
                      child: Text('Terrain'),
                    ),
                    const PopupMenuItem<MapType>(
                      value: MapType.hybrid,
                      child: Text('Hybrid'),
                    ),
                  ],
                ),
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
                  detail: true,
                  onPickMap: () {},
                  latLng: storyLocation,
                  placemark: placemark!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
