import 'package:flutter/material.dart';
import 'package:zokkyapp/screens/authenticate/register.dart';
import 'package:zokkyapp/screens/authenticate/sign_in.dart';
import 'package:zokkyapp/screens/authenticate/clipper.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

enum ViewState{
  SignInState,
  RegisterState,
  FirstPage,
}
class _AuthenticateState extends State<Authenticate> {

  ViewState viewState = ViewState.FirstPage;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void toggleView(ViewState viewStateVar) {
    setState(() => viewState = viewStateVar);
  }

  @override
  Widget build(BuildContext context) {

    if (viewState == ViewState.SignInState) {
      return SignIn(toggleView: toggleView);
    } else if (viewState == ViewState.RegisterState){
      return Register (toggleView: toggleView);
    }else if (viewState == ViewState.FirstPage){
      return Scaffold(
          resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          backgroundColor: Colors.grey[600],
          body: Column(
            children: <Widget>[
              Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 120),
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
                                        color: Colors.white
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
                                    "Zokky",
                                    style: TextStyle(
                                      fontSize: 53,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                            ),
                          ),
                          //second circle
                          Positioned(
                            width: 60,
                            height: 60,
                            top: 140,
                            left: 260,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          //third circle
                          Positioned(
                            width: 30,
                            height: 30,
                            top: 200,
                            left: 230,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              RaisedButton(
                highlightElevation: 0.0,
                splashColor: Color(0xFFC0F0E8),
                highlightColor: Color(0xFF80E1D1),
                elevation: 0.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)
                ),
                child: Text(
                  "    LOGIN    ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 20
                  ),
                ),
                onPressed: () {
                  toggleView(ViewState.SignInState);
                },
              ),
              OutlineButton(
                highlightedBorderColor: Colors.white,
                borderSide: BorderSide(
                    color: Colors.white, width: 2.0),
                    highlightElevation: 0.0,
                    splashColor: Colors.white,
                    highlightColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                child: Text(
                  "REGISTER",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
                onPressed: () {
                  toggleView(ViewState.RegisterState);
                },
              ),
              //curved line
              Expanded(
                child: Align(
                  child: ClipPath(
                    child: Container(
                      color: Colors.white,
                      height: 300,
                    ),
                    clipper: BottomWaveClipper(),
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              )
            ],
          )
      );
    }
  }
}
