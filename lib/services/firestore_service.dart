import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saloni1/models/User.dart';

class FirestoreService {
  final CollectionReference _carusersCollectionReference =
      Firestore.instance.collection('carusers');
  final CollectionReference _rescuersCollectionReference =
      Firestore.instance.collection('rescuers');

  Future createUser(User user) async {
    if (User.fromData(user.toJson()).userRole == 'Car User') {
      try {
        await _carusersCollectionReference
            .document(user.id)
            .setData(user.toJson());
      } catch (e) {
        return e;
      }
    } else if (User.fromData(user.toJson()).userRole == 'Rescuer') {
      try {
        await _rescuersCollectionReference
            .document(user.id)
            .setData(user.toJson());
      } catch (e) {
        return e;
      }
    }
  }

  Future getUser(String uid) async {
    var car = await _carusersCollectionReference.document(uid).get();
    var rescue = await _rescuersCollectionReference.document(uid).get();
    if (car.exists) {
      try {
        var userData = await _carusersCollectionReference.document(uid).get();
        return User.fromData(userData.data);
      } catch (e) {
        return e;
      }
    } else if (rescue.exists) {
      try {
        var userData = await _rescuersCollectionReference.document(uid).get();
        return User.fromData(userData.data);
      } catch (e) {
        return e;
      }
    }
  }
}
