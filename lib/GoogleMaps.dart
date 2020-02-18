import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final key = new GlobalKey<ScaffoldState>();

  static final CameraPosition _evKamreaPosPlex = CameraPosition(
    target: LatLng(41.123683, 28.7714727),
    zoom: 14.4746,
  );

  static final CameraPosition _evKamreaPos = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(41.123683, 28.7714727),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  static final CameraPosition _isYeriKamreaPos = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(41.0725272, 28.7954135),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _iseGit() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_isYeriKamreaPos));
  }
  Future<void> _eveGit() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_evKamreaPos));
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

    _marker_ekle_Leventler();
    _marker_ekle_Evim();

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        key: key,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: _drawer(),
        body: GoogleMap(
          mapType: MapType.normal, // MapType.hybrid uydu görünümü
          initialCameraPosition: _evKamreaPosPlex,
          markers: Set<Marker>.of(markers.values),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _eveGit,
          tooltip: 'Zoom',
          label: Text('Yaklaş bakim!'),
          icon: Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  void _marker_ekle_Leventler() {
    final MarkerId markerId1 = MarkerId("Leventler");
    final Marker marker = Marker(
      markerId: markerId1,
      position: LatLng(41.0725272, 28.7954135,),
      infoWindow: InfoWindow(title: "Leventler Asansör", snippet: 'Hoşgeldiniz.'),
      onTap: () {
        _showToast(context,'Navigasyonu başlat işe git');
        //navigasyonu başlatabilirsin
      },
    );
    setState(() {
      markers[markerId1] = marker;
    });
  }

  void _marker_ekle_Evim() {
    final MarkerId markerId1 = MarkerId("Evim");
    final Marker marker = Marker(
      markerId: markerId1,
      position: LatLng(41.123683, 28.7714727),
      infoWindow: InfoWindow(title: "Bizim evimiz", snippet: 'Sizi bize bekliyoruz.'),
      onTap: () {
        _showToast(context,'Navigasyonu başlat eve git');
        //navigasyonu başlatabilirsin
      },
    );
    setState(() {
      markers[markerId1] = marker;
    });
  }

  void _getLocation() async {
    var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final GoogleMapController controller = await _controller.future;

    setState(() {
      markers.clear();
      final MarkerId markerId1 = MarkerId("curr_loc");
      final marker = Marker(
        markerId: markerId1,
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Sizin konumunuz', snippet: 'Buradasınız.' + currentLocation.latitude.toString() + " " + currentLocation.longitude.toString()),
      );
      markers[markerId1] = marker;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17,
      ),
      ),);
    }
    );
  }

  Widget _drawer(){
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("xyz"),
            accountEmail: Text("xyz@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("xyz"),
            ),
            otherAccountsPictures: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("abc"),
              )
            ],
          ),
          ListTile(
            title: new Text("Adreslerim"),
            leading: new Icon(Icons.flight),
          ),
          Divider(),
          ListTile(
            title: new Text("İş Adresim"),
            trailing: new Icon(Icons.security),
            onTap: () async {
              Navigator.of(context).pop();
              _iseGit();
              _showToast(context,'İş Adresine gidiliyor');
            },
          ),
          ListTile(
            title: new Text("Ev Adresim"),
            trailing: new Icon(Icons.home),
            onTap: () async {
              Navigator.of(context).pop();
              _eveGit();
              _showToast(context,'Ev adresine gidiliyor');
            },
          ),
          ListTile(
            title: new Text("Konumumu bul"),
            trailing: new Icon(Icons.gps_fixed),
            onTap: () async {
              Navigator.of(context).pop();
              _getLocation();
              _showToast(context,'Konumunuz bulunuyor...');
            },
          ),

        ],
      ),
    );
  }

  // TODO: add onWillPop Callback,
  Future<bool> _willPopCallback() async {
    Navigator.of(context).pop(false);
    return false;
  }

  void _showToast(BuildContext context, String message) {
    key.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      action: SnackBarAction(
          label: 'Tamam', onPressed: key.currentState.hideCurrentSnackBar),
    ));
  }
}