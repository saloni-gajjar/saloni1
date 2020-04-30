import 'package:flutter/material.dart';
import 'package:saloni1/constants/route_names.dart';
import 'package:saloni1/ui/view/ambulance/amb_home_view.dart';
import 'package:saloni1/ui/view/login_view.dart';
import 'package:saloni1/ui/view/signup_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );

    case AmbHomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AmbHomeView(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
