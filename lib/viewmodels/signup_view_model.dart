import 'package:flutter/foundation.dart';
import 'package:saloni1/constants/route_names.dart';
import 'package:saloni1/locator.dart';
import 'package:saloni1/services/authentication_service.dart';
import 'package:saloni1/services/dialog_service.dart';
import 'package:saloni1/services/navigation_service.dart';

import 'base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  String _selectedRole = 'Select a User Role';

  String get selectedRole => _selectedRole;

  void setSelectedRole(dynamic role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future signUp({
    @required String email,
    @required String password,
    @required String fullName,
  }) async {
    setBusy(true);

    var result = await _authenticationService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        role: _selectedRole);

    setBusy(false);

    if (result is bool) {
      if (result) {
        if (_selectedRole == 'Car User') {
          _navigationService.navigateTo(CarHomeViewRoute);
        } else if (_selectedRole == 'Rescuer') {
          _navigationService.navigateTo(AmbHomeViewRoute);
        }
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: result,
      );
    }
  }
}
