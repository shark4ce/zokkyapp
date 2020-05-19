import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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
  final VoidCallback onRefresh;
  PostTile({this.post, this.index, this.user, this.onRefresh});
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
    setState(() {
      likeCount++;
      isLikedByUser = true;

    });
    likeReference = await db.addLike(widget.post.pid);
    return likeReference;
  }

  Future deleteLike() async {
    setState(() {
      likeCount--;
      isLikedByUser = false;

    });
    await likeReference.delete();
    await db.removeLike(widget.post.pid);
    return true;
  }

  void loadLikes(User user) async{
    QuerySnapshot q = await Firestore.instance
        .collection("likes")
        .where("pid", isEqualTo: widget.post.pid)
        .where("uid", isEqualTo: user.uid).getDocuments();

      if(q.documents.length > 0) {
        setState(() {
          isLikedByUser = true;
          likeReference = Firestore.instance.collection('likes').document(q.documents[0].documentID);
        });
      } else{
        setState(() {
          isLikedByUser = false;
        });
      }

    q = await Firestore.instance
            .collection("likes")
            .where("pid", isEqualTo: widget.post.pid).getDocuments();

          if(likeCount != q.documents.length) {
            setState(() {
              likeCount = q.documents.length;
            });
      }

  }


  Color decideColor() {
    if(isLikedByUser) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }

  getImage() {
    if(!requestedIndexes.contains(widget.post.pid)) {
      int maxSize = 10 * 1024 * 1024;
      imagesReference.child(widget.post.pid + widget.post.fileExtension).getData(maxSize).then((
          data) {
        this.setState((){
          imageFile = data;
          requestedIndexes.add(widget.post.pid);
        });
        imageData.putIfAbsent(widget.post.pid, (){
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
    if(!imageData.containsKey(widget.post.pid)){
      imageFile = null;
      loadLikes(widget.user);
      getImage();
    } else {
      this.setState((){
        imageFile = imageData[widget.post.pid];
      });
    }
    if(imageFile == null) {
      return Center(child:Text("Loading"));
    } else {
      return InkWell(
          onTap: (){ Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostView(post:widget.post, index:widget.index, user: widget.user, onRefresh: (){widget.onRefresh();},)),
          );
          widget.onRefresh();
          },
          child: Image.memory(imageFile, fit: BoxFit.cover));
    }
  }

  @override
  void initState() {
    super.initState();
    loadLikes(widget.user);

    if(!imageData.containsKey(widget.post.pid)){
      imageFile = null;
      getImage();
    } else {
      this.setState((){
        imageFile = imageData[widget.post.pid];
      });
    }
  }

  PopupMenuItem decideMenuItem(){
    if(widget.user.uid == widget.post.uid)
      return PopupMenuItem(
        value: 2,
        child: Text("Delete post")
      );
    else return null;
  }

  Future deletePost() async {

    await Firestore.instance.collection('posts').document(widget.post.pid).delete();
    widget.onRefresh();
    return true;
  }

  @override
  Widget build(BuildContext context) {

    db = new DatabaseService(user: widget.user);
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.only(top: 12.0),
      margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 15.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.white,),
                  elevation: 3.2,
                  onSelected: (value) async {
                    if(value == 1){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostView(post:widget.post, index:widget.index, user: widget.user,onRefresh: (){widget.onRefresh();})),
                      );
                      widget.onRefresh();
                    } else if(value == 2) {
                      await showDialog(
                        context:context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('Delete post'),
                            content: Text('Are you sure you want to delete the post?'),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () async{
                                    await deletePost();
                                    Navigator.of(context).pop();
                                  }
                              ),
                              FlatButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }
                              )
                            ],
                          );
                        },
                      );
                    }

                  },
                  itemBuilder: (context) =>[
                    PopupMenuItem(
                      value: 1,
                      child: Text("View post")
                    ),
                    decideMenuItem()
                  ],
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 8.0, bottom: 6.0),
              child: Text(widget.post.title,
                  style: TextStyle(fontSize: 25, color: Colors.white)),
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
                        color: Colors.grey[800],
                        child: Text('Like',
                            style: TextStyle(fontSize: 18))
                    ),
                    FlatButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PostView(post:widget.post, index:widget.index, user: widget.user,onRefresh: (){widget.onRefresh();})),
                          );
                          widget.onRefresh();
                        },
                        color: Colors.grey[800],
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