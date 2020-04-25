import 'package:flutter/material.dart';
import 'package:zokkyapp/screens/home/post_tile.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return PostTile();
      },
    );
  }
}