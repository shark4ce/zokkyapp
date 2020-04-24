import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zokkyapp/services/auth.dart';
import 'package:zokkyapp/screens/home/home.dart';

class CreatePost extends StatefulWidget {
  final Function toggleState;
  CreatePost({this.toggleState});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent[50],
      appBar: AppBar(
        title: Text('Zokky'),
        backgroundColor: Colors.deepOrangeAccent[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.arrow_back),
              label: Text('Back'),
              onPressed: () {
                widget.toggleState(AppState.feed);
              }
          ),
          FlatButton.icon(
            label: Text('LogOut'),
            icon: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Image.asset(
          'assets/images/Homepage-Design.jpg'
      ),
    );
  }
}