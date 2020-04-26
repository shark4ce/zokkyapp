import 'package:flutter/material.dart';
import 'package:zokkyapp/screens/authenticate/authenticate.dart';
import 'package:zokkyapp/services/auth.dart';
import 'package:zokkyapp/shared/constants.dart';
import 'package:zokkyapp/shared/loading.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:email_validator/email_validator.dart';


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
              widget.toggleView(ViewState.RegisterState);
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
                      }else if(result == "Verify Email"){
                        await showDialog(
                          context:context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text('Email is not verified'),
                              content: Text('Please, firstly verify your email!'),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      setState(() {
                                        loading = false;
                                      });
                                      Navigator.of(context).pop();
                                    }
                                )
                              ],
                            );
                          },
                        );
                      }else{
                        setState(() {
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
                SizedBox(height: 15.0),
                FacebookSignInButton(
                  onPressed: () async {
                    setState(() => loading = true);
                    dynamic result = await _auth.signInWithFacebook();
                    if (result == null) {
                      setState(() {
                        error = 'Sign In with Facebook failed!';
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
