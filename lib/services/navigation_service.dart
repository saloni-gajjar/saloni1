import 'package:flutter/material.dart';
import 'package:saloni1/constants/route_names.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  bool pop() {
    return _navigationKey.currentState.pop();
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    if (routeName == AmbHomeViewRoute ||
        routeName == CarHomeViewRoute ||
        routeName == LoginViewRoute) {
      return _navigationKey.currentState
          .pushReplacementNamed(routeName, arguments: arguments);
    } else
      return _navigationKey.currentState
          .pushNamed(routeName, arguments: arguments);
  }
}
