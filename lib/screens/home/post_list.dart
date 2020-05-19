import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zokkyapp/models/user.dart';
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


  void loadImages() async{

    QuerySnapshot q = await Firestore.instance
        .collection("posts").getDocuments();

          print("CC");

          setState(() {
            imagePaths.clear();
          });

          List<Post> buffer = new List<Post>();
          for(int i = 0; i < q.documents.length; i++) {
              DocumentSnapshot f = q.documents[i];
              Timestamp t = f.data['timestamp'];
              Post p = new Post(f.documentID, f.data['title'], f.data['description'], f.data['uid'], f.data['fileExtension'], t.toDate(), f.data['likes']);
              buffer.add(p);
              print("BUFF:" + buffer[i].likes.toString());
            }
          buffer.sort();

          for(int i = 0; i < buffer.length; i++) {
            setState(() {
              print("BUFF2:" + buffer[i].likes.toString());
              imagePaths.add(buffer[i]);
            });
          }

  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
      itemBuilder: (context, index) {
        if(index < imagePaths.length) {
          return new PostTile(post:imagePaths[index],index:index, user: user, onRefresh: (){ loadImages();},);
        } else{
          return null;
        }
      },
    );
  }
}