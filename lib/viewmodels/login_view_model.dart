import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:saloni1/constants/route_names.dart';
import 'package:saloni1/locator.dart';
import 'package:saloni1/services/authentication_service.dart';
import 'package:saloni1/services/dialog_service.dart';
import 'package:saloni1/services/navigation_service.dart';

import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future login({
    @required String email,
    @required String password,
  }) async {
    setBusy(true);

    var result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        var car = await Firestore.instance.collection('carusers')
            .document()
            .get();
        var rescue = await Firestore.instance.collection('rescuers')
            .document()
            .get();
        if (car.exists) {
          _navigationService.navigateTo(CarHomeViewRoute);
        } else if (rescue.exists) {
          _navigationService.navigateTo(AmbHomeViewRoute);
        } else {
          await _dialogService.showDialog(
            title: 'Login Failure',
            description: 'General login failure. Please try again later',
          );
        }
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }
  }
}
