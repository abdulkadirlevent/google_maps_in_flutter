import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  GoogleMaps({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GoogleMapsState createState() => new _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  // TODO: add state variables and methods
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(41.123683, 28.7714727),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(41.123683, 28.7714727),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  /*
   *    MapType (mapType: MapType.normal)
   * 1. normal: Normal tiles (traffic and labels, subtle terrain information).
   * 2. satellite: Satellite imaging tiles (aerial photos).
   * 3. terrain: Terrain tiles (indicates type and height of terrain).
   * 4. hybrid: Hybrid tiles (satellite images with some labels/overlays).
   */
  @override
  Widget build(BuildContext context) {
    // TODO: add widget build method
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: GoogleMap(
          mapType: MapType.normal, // MapType.hybrid uydu görünümü
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          tooltip: 'Zoom',
          label: Text('Yaklaş bakim!'),
          icon: Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  // TODO: add onWillPop Callback,
  Future<bool> _willPopCallback() async {
    Navigator.of(context).pop(false);
    //Navigator.pop(context, 'MerhabaDostum');
    return false;
  }
}