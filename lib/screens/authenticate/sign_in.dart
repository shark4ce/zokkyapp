import 'package:flutter/material.dart';
import 'package:zokkyapp/screens/authenticate/authenticate.dart';
import 'package:zokkyapp/services/auth.dart';
import 'package:zokkyapp/shared/loading.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


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

  Future<bool> _onBackPressed() {
    widget.toggleView(ViewState.FirstPage);
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    WillPopScope(
        onWillPop: _onBackPressed,
        child:Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 240,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                      child: Container(
                                        child: Align(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context).primaryColor
                                            ),
                                            width: 150,
                                            height: 150,
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        height: 154,
                                      )
                                  ),
                                  //first circle
                                  Positioned(
                                    child: Container(
                                        height: 154,
                                        width: MediaQuery.of(context).size.width,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "LOGIN",
                                            style: TextStyle(
                                              fontSize: 56,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                          validator: (val) => val.isEmpty ? 'Enter a valid email' : null,
                          obscureText: false,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              hintText: "EMAIL",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3,
                                ),
                              ),
                              prefixIcon: Padding(
                                child: IconTheme(
                                  data: IconThemeData(color: Theme.of(context).primaryColor),
                                  child: Icon(
                                    Icons.email
                                  ),
                                ),
                                padding: EdgeInsets.only(left: 30, right: 10),
                              )
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          validator: (val) => val.length <= 6 ? 'Enter a password with minim 6 characters' : null,
                          obscureText: true,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              hintText: "PASSWORD",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3,
                                ),
                              ),
                              prefixIcon: Padding(
                                child: IconTheme(
                                  data: IconThemeData(color: Theme.of(context).primaryColor),
                                  child: Icon(
                                      Icons.lock
                                  ),
                                ),
                                padding: EdgeInsets.only(left: 30, right: 10),
                              )
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        highlightElevation: 0.0,
                        splashColor: Color(0xFFC0F0E8),
                        highlightColor: Color(0xFF80E1D1),
                        elevation: 0.0,
                        color:  Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                        ),
                        child: Text(
                          "    LOGIN    ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20
                          ),
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
                          },
                      ),
                      SizedBox(height: 12.0),
                      SignInButton(
                        Buttons.GoogleDark,
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
                      SignInButton(
                        Buttons.Facebook,
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
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 15.0),
                      ),
                    ],
                  )
              ),
            ),
          )
      )
    );
  }
}
