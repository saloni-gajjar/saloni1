import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:saloni1/ui/shared/ui_helpers.dart';
import 'package:saloni1/ui/widgets/busy_button.dart';
import 'package:saloni1/ui/widgets/expansion_list.dart';
import 'package:saloni1/viewmodels/signup_view_model.dart';


class SignUpView extends StatefulWidget {
  SignUpView({this.auth, this.logoutCallBack});

  //final AuthenticationService _authenticationService =
  //locator<AuthenticationService>();
  final FirebaseAuth auth;
  final VoidCallback logoutCallBack;

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  final _formKey = new GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final numberplateController = TextEditingController();
  final licenseController = TextEditingController();
  final empidController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpViewModel>.withConsumer(
      viewModel: SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: new AppBar(
          title: new Text('Sign Up',
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
        ),
        body: new Container(
            padding: EdgeInsets.all(16.0),
            child: new Form(
                key: _formKey,
                child: new ListView(shrinkWrap: true, children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20.0,
                      child: new Icon(Icons.local_hospital,
                          color: Colors.red, size: 100.0),
                    ),
                  ),
                  verticalSpaceMedium,
                  verticalSpaceMedium,
                  Text(
                    "TO THE RESCUE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "for Rescuers",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                  ),
                  verticalSpaceMedium,
                  ExpansionList<String>(
                      items: ['Rescuer'],
                      title: model.selectedRole,
                      onItemSelected: model.setSelectedRole),
                  verticalSpaceMedium,
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Full Name',
                        icon: new Icon(
                          Icons.person,
                          color: Colors.grey,
                        )),
                    controller: fullNameController,
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Employee ID',
                        icon: new Icon(
                          Icons.person_pin,
                          color: Colors.grey,
                        )),
                    controller: empidController,
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Email ID',
                        icon: new Icon(
                          Icons.email,
                          color: Colors.grey,
                        )),
                    controller: emailController,
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    maxLines: 1,
                    maxLength: 10,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    obscureText: true,
                    decoration: new InputDecoration(
                        hintText: 'Password',
                        counterText: 'Minimum 6 characters',
                        icon: new Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        )),
                    controller: passwordController,
                  ),
                  verticalSpaceSmall,

                  TextFormField(
                    maxLines: 1,
                    maxLength: 10,
                    maxLengthEnforced: true,
                    keyboardType: TextInputType.phone,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Phone Number',
                        suffixText: ' Should be 10 digits',
                        icon: new Icon(
                          Icons.phone,
                          color: Colors.grey,
                        )),
                    controller: phoneController,
                  ),
                  verticalSpaceSmall,

                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Vehicle Number',
                        icon: new Icon(
                          Icons.directions_car,
                          color: Colors.grey,
                        )),
                    controller: numberplateController,
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Driving License Number',
                        icon: new Icon(
                          Icons.credit_card,
                          color: Colors.grey,
                        )),
                    controller: licenseController,
                  ),
                  verticalSpaceMassive,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BusyButton(
                        title: 'Sign Up',
                        busy: model.busy,
                        onPressed: () {
                          model.signUp(
                              email: emailController.text,
                              password: passwordController.text,
                              fullName: fullNameController.text,
                              emp_id: empidController.text,
                              phone_number: phoneController.text,
                              vehicle_number: numberplateController.text,
                              license_number: licenseController.text
                          );
                        },
                      )
                    ],
                  )
                ]
                )
            )
        ),
      ),
    );
  }
}



