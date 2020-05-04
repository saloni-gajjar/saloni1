import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

//import 'package:firebase_database/firebase_database.dart';
//import 'dart:async';

class AllRescuersView extends StatefulWidget {
  AllRescuersView({Key key, this.auth}) : super(key: key);

  final FirebaseAuth auth;

  //final VoidCallback OnSignedOut;

  @override
  State<StatefulWidget> createState() => new _AllRescuersViewState();
}

class _AllRescuersViewState extends State<AllRescuersView> {
  //final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<MarkerId, Marker> marks = <MarkerId, Marker>{};
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  FirebaseUser mCurrentUser;


  /*GeoFirePoint center = geo.point(latitude: 12.960632, longitude: 77.641603);

// get the collection reference or query
  var collectionReference = _firestore.collection('locations');

  double radius = 50;
  String field = 'position';

  Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef: collectionReference)
      .within(center: center, radius: radius, field: field);*/

  @override
  void initState() {
    //_auth = FirebaseAuth.instance;
    //_getCurrentUser();
    populateClients();
    super.initState();
  }

  /*_getCurrentUser () async {
    mCurrentUser = await _auth.currentUser();
    DocumentSnapshot item = await Firestore.instance.collection("rescuers").document(mCurrentUser.email).get(); //If //I delete this line everything works fine but I don't have user name.
    _uname = item['fullName'];
   }*/

  populateClients() async {
    //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    //FirebaseUser user = await firebaseAuth.currentUser();

    List list_of_rescuers = await Firestore.instance.collection('rescuers')
        .getDocuments()
        .then((val) => val.documents);
    for (int i = 0; i < list_of_rescuers.length; i++) {
      Firestore.instance.collection('rescuers').document(
          list_of_rescuers[i].documentID.toString())
          .collection('location').snapshots().listen(CreateListofLocations);
    }

  }
  CreateListofLocations(QuerySnapshot snapshot) async {
    var docs = snapshot.documents;
    initMarker(docs[0].data, docs[0].documentID);

  }
  initMarker(client, requestId) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarkerWithHue(125.0),
        position: LatLng(client['position']['geopoint'].latitude,
            client['position']['geopoint'].longitude),
        infoWindow: InfoWindow(title: client["name"])
    );
    setState(() {
      marks[markerId] = marker;
      // print(markerId);
    });
  }

//makeCollection to be edited, please ignore this function
  /*Future _makecollection() async {

    var collectionReference2 = firestore.collection('radius_resc');
    var collectionReference1 = firestore.collection('latest_resc');
    if (collectionReference2!=null) {collectionReference2.getDocuments().then((docs) {
      for (var document in docs.documents) {document.reference.delete();}
    });}
    if (collectionReference1!=null) {collectionReference1.getDocuments().then((docs) {
      for (var document in docs.documents) {document.reference.delete();}
    });}
    latest_locs();
    double radius = 5;
    String field = 'position';
    var pos = await firestore.collection('markers').getDocuments().then((val) {
      return val.documents[0].data["location"];
    });
    GeoFirePoint center = geo.point(
        latitude: pos.latitude, longitude: pos.longitude);
    Stream<List> stream = geo.collection(
        collectionRef: collectionReference1)
        .within(center: center, radius: radius, field: field);
    stream.listen((List documentList) {
      for (var value in documentList) {
        firestore.collection('radius_resc').add(value.data);
      }
    });
 }*/
  Future _makecollection() async {
    var collectionReference2 = firestore.collection('radius_resc');
    var collectionReference1 = firestore.collection('latest_resc');
    if (collectionReference2 != null) {
      collectionReference2.getDocuments().then((docs) {
        for (var document in docs.documents) {
          document.reference.delete();
        }
      });
    }
    if (collectionReference1 != null) {
      collectionReference1.getDocuments().then((docs) {
        for (var document in docs.documents) {
          document.reference.delete();
        }
      });
    }
    latest_locs();
    double radius = 50;
    String field = 'position';
    var center = await firestore.collection('markers').getDocuments().then((
        val) {
      return val.documents[0].data["location"];
    });
    await Firestore.instance.collection('latest_resc')
        .getDocuments()
        .then((val) {
      for (var i = 0; i < val.documents.length; i++) {
        var loc = val.documents[i].data["position"]["geopoint"];
        var ans = compare(
            center.latitude, center.longitude, loc.latitude, loc.longitude,
            radius);
        if (ans == 0) {
          firestore.collection('radius_resc').add(val.documents[i].data);
        }
      }
    });
  }


  latest_locs() async {
    List list_of_rescuers = await Firestore.instance.collection('rescuers')
        .getDocuments()
        .then((val) => val.documents);
    for (int i = 0; i < list_of_rescuers.length; i++) {
      Firestore.instance.collection('rescuers').document(
          list_of_rescuers[i].documentID.toString())
          .collection('location').snapshots().listen((
          QuerySnapshot snapshot) async {
        var docs = snapshot.documents;
        Firestore.instance.collection('latest_resc').add(docs[0].data);
      }
      );
    }
  }

  double compare(lat1, lon1, lat2, lon2, radius) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p)) / 2;
    var dis = 12742 * asin(sqrt(a));
    return ((dis <= radius) ? 0 : 1);
  }


  Future _addGeopoint(LocationData pos) async {
    //var pos = await _locationTracker.getLocation();
    GeoFirePoint point =
    geo.point(latitude: pos.latitude, longitude: pos.longitude);

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await firebaseAuth.currentUser();
    DocumentSnapshot item = await Firestore.instance.collection("rescuers")
        .document(user.email)
        .get(); //If //I delete this line everything works fine but I don't have user name.
    String _uname = item['fullName'];
    // print(_uname);
    return firestore.collection('rescuers').document(user.email).collection(
        'location').add({'position': point.data, 'name': _uname});
  }



  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(20.537319, 72.941048),
    zoom: 7,
  );


  void updatelocation() async {
    try {
      //Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      _addGeopoint(location);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((pos) {
            if (_controller != null) {
              _controller.animateCamera(CameraUpdate.newCameraPosition(
                  new CameraPosition(
                      bearing: 192.8334901395799,
                      target: LatLng(pos.latitude, pos.longitude),
                      tilt: 0,
                      zoom: 11.00)));
              _addGeopoint(pos);
            }
          });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  /*signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Rescuers'),
        actions: <Widget>[FlatButton(onPressed: () {
          _makecollection();
        }, child: Icon(Icons.collections_bookmark))
        ],

      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        markers: Set<Marker>.of(marks.values),
        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            updatelocation();
            //getCurrentLocation();
          }),

    );
  }


}
