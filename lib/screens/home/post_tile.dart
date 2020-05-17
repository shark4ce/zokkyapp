import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zokkyapp/models/post.dart';
import 'package:zokkyapp/models/user.dart';
import 'package:zokkyapp/screens/home/data_holder.dart';
import 'package:zokkyapp/screens/home/post_view.dart';
import 'package:zokkyapp/services/database.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final int index;
  final User user;
  PostTile({this.post, this.index, this.user});
  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {

  StorageReference imagesReference = FirebaseStorage.instance.ref().child("images");
  Uint8List imageFile;
  int likeCount = 0;
  bool isLikedByUser = false;
  DatabaseService db;
  DocumentReference likeReference;

  Future addLike() async {
    likeReference = await db.addLike(widget.post.pid);
    return likeReference;
  }

  Future deleteLike() async {
    await likeReference.delete();
    return true;
  }

  void loadLikes(User user) {
    Firestore.instance
        .collection("likes")
        .where("pid", isEqualTo: widget.post.pid)
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      if(snapshot.documents.length > 0) {
        setState(() {
          isLikedByUser = true;
          likeReference = Firestore.instance.collection('likes').document(snapshot.documents[0].documentID);
        });
      } else{
        setState(() {
          isLikedByUser = false;
        });
      }
    });
    Firestore.instance
        .collection("likes")
        .where("pid", isEqualTo: widget.post.pid)
        .snapshots()
        .listen((snapshot) {
      if(likeCount != snapshot.documents.length) {
        setState(() {
          likeCount = snapshot.documents.length;
        });
      }
    });
  }


  Color decideColor() {
    if(isLikedByUser) {
      return Colors.blue;
    } else {
      return Colors.black;
    }
  }

  getImage() {
    if(!requestedIndexes.contains(widget.index)) {
      int maxSize = 10 * 1024 * 1024;
      imagesReference.child(widget.post.pid + widget.post.fileExtension).getData(maxSize).then((
          data) {
        this.setState((){
          imageFile = data;
          requestedIndexes.add(widget.index);
        });
        imageData.putIfAbsent(widget.index, (){
          return data;
        });
      }).catchError((error) {
        imageFile = null;
        imagesReference = FirebaseStorage.instance.ref().child("images");
      });

    } else {

    }
  }

  Widget decideTileWidget() {
    if(imageFile == null) {
      return Center(child:Text("Loading"));
    } else {
      return Image.memory(imageFile, fit: BoxFit.cover);
    }
  }

  @override
  void initState() {
    super.initState();
    loadLikes(widget.user);
    if(!imageData.containsKey(widget.index)){
      getImage();
    } else {
      this.setState((){
        imageFile = imageData[widget.index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    db = new DatabaseService(user: widget.user);
    return Container(
      color: Colors.cyan[200],
      padding: const EdgeInsets.only(top: 12.0),
      margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 15.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Container(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(widget.post.title,
              style: TextStyle(fontSize: 25)),
            ),
            decideTileWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(likeCount.toString() + " Likes",
                      style: TextStyle(fontSize: 18, color: decideColor())),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () async {

                          if(isLikedByUser) {
                            await deleteLike();
                          } else {
                            await addLike();
                          }
                        },
                        color: Colors.amber,
                        child: Text('Like',
                            style: TextStyle(fontSize: 18))
                    ),
                    FlatButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PostView(post:widget.post, index:widget.index, user: widget.user,)),
                          );
                        },
                        color: Colors.amber,
                        child: Text('Comment',
                            style: TextStyle(fontSize: 18))
                    )
                  ],
                ),
              ],
            )
          ]
      ),
    );
  }
}