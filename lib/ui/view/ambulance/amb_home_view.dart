//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' show atan2, cos, pi, sin, sqrt;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saloni1/ui/shared/ui_helpers.dart';
import 'package:saloni1/ui/view/ambulance/all_rescuers_view.dart';
import 'package:saloni1/ui/view/ambulance/route_page_view.dart';

import 'amb_map_view.dart';
import 'profilepage.dart';


class AmbHomeView extends StatefulWidget {
  AmbHomeView({this.auth});

  //final AuthenticationService _authenticationService =
  //locator<AuthenticationService>();
  final FirebaseAuth auth;

  //final VoidCallback logoutCallBack;


  @override
  _AmbHomeViewState createState() => _AmbHomeViewState();
}

class _AmbHomeViewState extends State<AmbHomeView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseUser mCurrentUser;
  String _uname;
  FirebaseAuth _auth;
  DocumentReference ref;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
    _accident();
  }

  _accident() {
    Firestore.instance.collection("markers").snapshots().listen((result) {
      result.documentChanges.forEach((res) {
        if ((res.type == DocumentChangeType.added) ||
            (res.type == DocumentChangeType.modified)) {
          _makecollection();
        }
      });
    });
  }

  Future _makecollection() async {
    var collectionReference2 = Firestore.instance.collection('radius_resc');
    if (collectionReference2 != null) {
      collectionReference2.getDocuments().then((docs) {
        for (var document in docs.documents) {
          document.reference.delete();
          print("radius_resc deleted");
        }
      });
    }
    latest_locs();
    double radius = 20; //kilometers
    var center = await Firestore.instance.collection('markers')
        .getDocuments()
        .then((val) {
      print(val.documents[val.documents.length - 1].data["clientName"]);
      return val.documents[val.documents.length - 1].data["location"];
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
          Firestore.instance.collection('radius_resc').add(
              val.documents[i].data);
        }
      }
    });
  }


  // ignore: non_constant_identifier_names
  latest_locs() async {
    var collectionReference1 = Firestore.instance.collection('latest_resc');
    if (collectionReference1 != null) {
      collectionReference1.getDocuments().then((docs) {
        for (var document in docs.documents) {
          document.reference.delete();
          print("latest_resc deleted");
        }
      });
    }
    List listOfRescuers = await Firestore.instance.collection('rescuers')
        .getDocuments()
        .then((val) => val.documents);
    for (int i = 0; i < listOfRescuers.length; i++) {
      Firestore.instance.collection('rescuers').document(
          listOfRescuers[i].documentID.toString())
          .collection('location').snapshots().listen((
          QuerySnapshot snapshot) async {
        var docs = snapshot.documents;
        Firestore.instance.collection('latest_resc').add(docs[0].data);
        print(docs[0].data["name"]);
      }
      );
    }
  }

  double compare(lat1, lon1, lat2, lon2, radius) {
    const R = 6371e3;
    var l1 = lat1 * pi / 180;
    var l2 = lat2 * pi / 180;
    var delta_lat = (lat2 - lat1) * pi / 180;
    var delta_lon = (lon2 - lon1) * pi / 180;
    var a = sin(delta_lat / 2) * sin(delta_lat / 2)
        + cos(l1) * cos(l2) * sin(delta_lon / 2) * sin(delta_lon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; //meters
    var dis = d / 1000; //kilometers
    print(dis); //kilometers
    return ((dis <= radius) ? 0 : 1);
  }



  _getCurrentUser() async {
    mCurrentUser = await _auth.currentUser();
    DocumentSnapshot item = await Firestore.instance.collection("rescuers")
        .document(mCurrentUser.email)
        .get(); //If //I delete this line everything works fine but I don't have user name.
    _uname = item['fullName'];
    setState(() {});
  }

  // final AuthenticationService authenticationService;//check

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Welcome Rescuer"), actions: <Widget>[
          //FlatButton(onPressed: () async {authenticationService.signOut();}, child: Text("Logout"))
        ]),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[
                        Colors.deepOrange,
                        Colors.orangeAccent
                      ])),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Material(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/ambulance.jpg',
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(_uname,
                            style:
                            TextStyle(color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )),
              CustomListTile(
                Icons.person,
                'Profile',
                    () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new NewPage("Your Profile")));
                },
              ),
              CustomListTile(
                Icons.history,
                'History',
                    () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new NewPage("Your History")));
                },
              ),
              CustomListTile(Icons.lock, 'Logout', () {}),
            ],
          ),
        ),
        body: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => AmbMapView()));
                    },
                    child: Text(
                      "View Current Location",

                      style: TextStyle(color: Colors.white),
                    )
                ),
                verticalSpaceSmall,
                FlatButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => RoutePageView()));
                    },
                    child: Text(
                      "View Location of Accident Detection",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )
                ),
                verticalSpaceSmall,
                FlatButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => AllRescuersView()));
                    },
                    child: Text(
                      "View Other Rescuers",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )
                )

              ],)
          ],)
    );
  }
}


// ignore: must_be_immutable
class CustomListTile extends StatefulWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
          splashColor: Colors.orangeAccent,
          onTap: widget.onTap,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(widget.icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.text,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
