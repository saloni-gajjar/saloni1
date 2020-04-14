import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AmbHomeView extends StatelessWidget {
  AmbHomeView({this.auth, this.onSignedOut});

  final FirebaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Welcome'), actions: <Widget>[]),
      body: Center(
        child: Text('Ambulance Home'),
      ),
    );
  }
}
