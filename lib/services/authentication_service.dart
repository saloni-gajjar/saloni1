import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:saloni1/locator.dart';
import 'package:saloni1/models/User.dart';
import 'package:saloni1/services/firestore_service.dart';
import 'package:saloni1/ui/view/ambulance/amb_home_view.dart';

import 'navigation_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  User _currentUser;

  User get currentUser => _currentUser;

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } catch (e) {
      print("Error : $e");
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String role,
    @required String emp_id,
    @required String phone_number,
    @required String vehicle_number,
    @required String license_number,


  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      _currentUser = User(
        //id: authResult.user.email,
        email: authResult.user.email,
        fullName: fullName,
        userRole: role,
        emp_id: emp_id,
        phone_number: phone_number,
        vehicle_number: vehicle_number,
        license_number: license_number,
      );

      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user).then((v) {});
    if (_currentUser != null) {
      if (_currentUser.userRole == "Rescuer")
        return new AmbHomeView();
    }
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.email);
    }
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    return _navigationService.navigateTo("LoginView");
  }
}
