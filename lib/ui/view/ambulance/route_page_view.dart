//import 'dart:async';

//import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutePageView extends StatefulWidget {
  RoutePageView({Key key, this.auth}) : super(key: key);
  final FirebaseAuth auth;

  @override
  State<StatefulWidget> createState() => _RoutePageViewState();
}

// ignore: camel_case_types
class _RoutePageViewState extends State<RoutePageView> {
  //GoogleMapController _controller;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<MarkerId, Marker> marks = <MarkerId, Marker>{};

  @override
  void initState() {
    populateClients();
    super.initState();
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(20.537319, 72.941048),
    zoom: 7,
  );

  populateClients() {
    Firestore.instance.collection('markers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          initMarker(docs.documents[0].data, docs.documents[0].documentID);
        }
      }
    });
  }

  initMarker(client, requestId) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(125.0),
      position:
          LatLng(client['location'].latitude, client['location'].longitude),
    );
    setState(() {
      marks[markerId] = marker;
      print(markerId);
    });
  }

  /*Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accident Detected'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set<Marker>.of(marks.values),
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          // _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching), onPressed: () {}),
    );
  }
}
