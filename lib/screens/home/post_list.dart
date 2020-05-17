import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zokkyapp/models/user.dart';
import 'package:zokkyapp/screens/home/post_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zokkyapp/models/post.dart';

import 'data_holder.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

List<Post> imagePaths = new List<Post>();

class _PostListState extends State<PostList> {
  @override
  initState() {
    super.initState();
    loadImages();
  }


  void loadImages() {
    Firestore.instance
        .collection("posts")
        .snapshots()
        .listen( (snapshot) {
          if(imagePaths.length > snapshot.documents.length){
            setState(() {
              imagePaths.clear();
              requestedIndexes.clear();
              imageData.clear();
            });
          }
          int count = imagePaths.length;
          for(int i = 0; i < snapshot.documents.length; i++) {
            DocumentSnapshot f = snapshot.documents[i];
            if(count > 0) {
              int j;
              for(j = 0; j < imagePaths.length; j++) {
                if(f.documentID == imagePaths[j].pid) {
                  count--;
                  break;
                }
              }
              if(j == imagePaths.length) {
                setState((){
                  imagePaths.add(new Post(f.documentID, f.data['title'], f.data['description'], f.data['uid'], f.data['fileExtension']));
                });
              }
            } else {
              setState((){
                imagePaths.add(new Post(f.documentID, f.data['title'], f.data['description'], f.data['uid'], f.data['fileExtension']));
              });
            }

          }
    });
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
      itemBuilder: (context, index) {
        if(index < imagePaths.length) {
          return new PostTile(post:imagePaths[index],index:index, user: user,);
        } else{
          return null;
        }
      },
    );
  }
}