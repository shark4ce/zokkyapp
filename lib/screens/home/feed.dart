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

  Widget listItem() {
    return Container(
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage(
              'assets/images/Homepage-Design.jpg'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
      margin: EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        onTap: () {
          print("Bam");
        },
        title: Container(
          margin: EdgeInsets.only(left: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 13.0),
                child: Text(
                  "Salut!",
                  style: TextStyle(fontFamily: 'SF-Display-Regular', fontSize: 13.0, color: Colors.white),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                padding: const EdgeInsets.only(bottom: 20.0),
                child: new Text(
                  "Yooooo",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontFamily: 'SF-Display-Semibold', fontSize: 22.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 28),
          child: Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ),
    );
  }


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