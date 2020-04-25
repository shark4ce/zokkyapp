import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zokkyapp/screens/home/post_list.dart';
import 'package:zokkyapp/services/auth.dart';
import 'package:zokkyapp/screens/home/home.dart';

class Feed extends StatefulWidget {
  final Function toggleState;
  Feed({this.toggleState});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Zokky'),
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.arrow_upward),
              label: Text('CreatePost'),
              onPressed: () {
                widget.toggleState(AppState.createPost);
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
      body: PostList(),
    );
  }
}