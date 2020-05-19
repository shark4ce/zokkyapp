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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Zokky'),
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.arrow_upward, color: Colors.white,),
              label: Text('CreatePost', style: TextStyle(color: Colors.white)),
              onPressed: () {
                widget.toggleState(AppState.createPost);
              }
          ),
          FlatButton.icon(
            label: Text('LogOut', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.person, color: Colors.white,),
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