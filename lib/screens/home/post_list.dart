import 'package:flutter/material.dart';
import 'package:zokkyapp/screens/home/post_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zokkyapp/models/post.dart';

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

  void add(DocumentSnapshot snap) {
    imagePaths.add(new Post(snap.documentID, snap.data['title'], snap.data['description'], snap.data['uid'], snap.data['fileExtension']));
  }

  void loadImages() {
    Firestore.instance
        .collection("posts")
        .snapshots()
        .listen( (snapshot) {
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
                imagePaths.add(new Post(f.documentID, f.data['title'], f.data['description'], f.data['uid'], f.data['fileExtension']));
              }
            } else {
              imagePaths.add(new Post(f.documentID, f.data['title'], f.data['description'], f.data['uid'], f.data['fileExtension']));
            }

          }
    });
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
      itemBuilder: (context, index) {
        print(imagePaths.length);
        if(index < imagePaths.length) {
          return new PostTile(post:imagePaths[index],index:index);
        } else{
          return null;
        }
      },
    );
  }
}