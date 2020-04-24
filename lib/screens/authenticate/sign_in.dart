import 'package:flutter/material.dart';
import 'package:zokkyapp/screens/authenticate/authenticate.dart';
import 'package:zokkyapp/services/auth.dart';
import 'package:zokkyapp/shared/constants.dart';
import 'package:zokkyapp/shared/loading.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';


class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in'),
        actions: <Widget>[
          //go to register button
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () {
              widget.toggleView();
            }
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //email
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Enter a valid email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    }
                ),
                //password
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    validator: (val) => val.length <= 0 ? 'Enter a password with minim 6 characters' : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    }
                ),
                //Sign In Button
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Wrong email or password!';
                          loading = false;
                        });
                      }
                    }
                  }
                ),
                SizedBox(height: 15.0),
                GoogleSignInButton(
                  darkMode: true,
                  onPressed: () async {
                    setState(() => loading = true);
                    dynamic result = await _auth.signInWithGoogle();
                    if (result == null) {
                      setState(() {
                        error = 'Sign In with Google failed!';
                        loading = false;
                      });
                    }
                  },
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 15.0),
                ),
              ],
            ),
        )
        )
      ),
    );
  }
}
