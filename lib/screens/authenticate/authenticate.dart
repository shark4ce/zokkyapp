import 'package:flutter/material.dart';
import 'package:zokkyapp/screens/authenticate/register.dart';
import 'package:zokkyapp/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

enum ViewState{
  SignInState,
  RegisterState,
}
class _AuthenticateState extends State<Authenticate> {

  ViewState viewState = ViewState.SignInState;

  void toggleView(ViewState viewStateVar) {
    setState(() => viewState = viewStateVar);
  }

  @override
  Widget build(BuildContext context) {

    if (viewState == ViewState.SignInState) {
      return SignIn(toggleView: toggleView);
    } else if (viewState == ViewState.RegisterState){
      return Register (toggleView: toggleView);
    }
  }
}
