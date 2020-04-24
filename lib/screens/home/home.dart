import 'package:flutter/material.dart';
import 'package:zokkyapp/screens/home/create_post.dart';
import 'package:zokkyapp/screens/home/feed.dart';

enum AppState {
  feed,
  createPost
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AppState state = AppState.feed;

  void toggleState(AppState newState) {
    setState(() => state = newState);
  }

  @override
  Widget build(BuildContext context) {
    switch(state) {
      case AppState.feed:
        return Feed(toggleState: toggleState);
        break;
      case AppState.createPost:
        return CreatePost(toggleState: toggleState);
        break;
      default:
        return Feed(toggleState: toggleState);
        break;
    }
  }
}
