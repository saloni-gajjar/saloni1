import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saloni1/locator.dart';
import 'package:saloni1/services/authentication_service.dart';




class AmbHomeView extends StatelessWidget {
  AmbHomeView({this.auth, this.onSignedOut});

  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();
  final FirebaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Welcome'), actions: <Widget>[
        FlatButton(onPressed: () {
          _authenticationService.signOut();
        }, child: Text("LOGOUT"))
      ]),
      body: Center(
        child: Text('Ambulance Home'),
      ),
    );
  }
}
