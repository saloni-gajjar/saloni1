import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:saloni1/ui/shared/ui_helpers.dart';
import 'package:saloni1/ui/widgets/busy_button.dart';
import 'package:saloni1/ui/widgets/expansion_list.dart';
import 'package:saloni1/ui/widgets/input_field.dart';
import 'package:saloni1/viewmodels/signup_view_model.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final numberplateController = TextEditingController();

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
              verticalSpaceMedium,
              InputField(
                placeholder: 'Full Name',
                controller: fullNameController,
              ),
              verticalSpaceSmall,
              InputField(
                placeholder: 'Email',
                controller: emailController,
              ),
              verticalSpaceSmall,
              InputField(
                placeholder: 'Password',
                password: true,
                controller: passwordController,
                additionalNote: 'Password has to be a minimum of 6 characters.',
              ),
              verticalSpaceSmall,
              ExpansionList<String>(
                  items: ['Car User', 'Rescuer'],
                  title: model.selectedRole,
                  onItemSelected: model.setSelectedRole),
              verticalSpaceMedium,
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
                          fullName: fullNameController.text);
                    },
                  )
                ],
              )
            ])),
      ),
    );
  }
}
