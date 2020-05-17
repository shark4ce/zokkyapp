import 'package:flutter/material.dart';
import 'package:zokkyapp/screens/authenticate/authenticate.dart';
import 'package:zokkyapp/services/auth.dart';
import 'package:zokkyapp/shared/loading.dart';


class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

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
                                              width: 130,
                                              height: 130,
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          height: 140,
                                        )
                                    ),
                                    //first circle
                                    Positioned(
                                      child: Container(
                                        padding: EdgeInsets.only(bottom: 120, right: 45),
                                        child: Text(
                                          "REGI",
                                          style: TextStyle(
                                            fontSize: 44,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    Positioned(
                                      child: Align(
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 45, left: 32),
                                          width: 130,
                                          child: Text(
                                            "STER",
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
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
                                  padding: EdgeInsets.only(left: 20, right: 10),
                                )
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
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
                                  padding: EdgeInsets.only(left: 20, right: 10),
                                )
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                            "CREATE ACCOUNT",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.registerWithEmailAndPassword(email, password);

                              if (result == null) {
                                setState(() {
                                  error = 'Please try again with valid credentials!';
                                  loading = false;
                                });
                              }else if(result == "Verify Email"){
                                await showDialog(
                                  context:context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text('Verify email'),
                                      content: Text('Account created!\r\nPlease verify your email and LogIn!'),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              setState(() {
                                                widget.toggleView(ViewState.SignInState);
                                                loading = false;
                                              });
                                              Navigator.of(context).pop();
                                            }
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                        SizedBox(height: 12.0),
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
