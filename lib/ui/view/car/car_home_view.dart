import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'car_map_view.dart';
import 'profilepage.dart';

class CarHomeView extends StatelessWidget {
  CarHomeView({this.auth, this.logoutCallBack});

  final FirebaseAuth auth;
  final VoidCallback logoutCallBack;

  // final AuthenticationService authenticationService;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Welcome'), actions: <Widget>[
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
                          child: Text(
                            'Car User',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.0),
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
              CustomListTile(Icons.lock, 'Log Out', () => {}),
            ],
          ),
        ),
        body: Center(
            child: FlatButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CarMapView()));
                },
                child: Text(
                  "View Current Location",
                  style: TextStyle(color: Colors.white),
                ))));
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
