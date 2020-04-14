import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:saloni1/locator.dart';
import 'package:saloni1/models/User.dart';
import 'package:saloni1/services/firestore_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);
  final FirestoreService _firestoreService = locator<FirestoreService>();

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
      print("Error");
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String role,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      _currentUser = User(
        id: authResult.user.uid,
        email: email,
        fullName: fullName,
        userRole: role,
      );

      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user);
    return user != null;
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
