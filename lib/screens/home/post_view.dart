import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zokkyapp/models/post.dart';
import 'package:zokkyapp/models/comment.dart';
import 'package:zokkyapp/models/user.dart';
import 'package:zokkyapp/screens/home/data_holder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zokkyapp/services/database.dart';
import 'package:zokkyapp/shared/constants.dart';

class PostView extends StatefulWidget {
  final Post post;
  final int index;
  final User user;
  final VoidCallback onRefresh;
  PostView({this.post, this.index, this.user, this.onRefresh});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {

  List<Comment> comments = new List<Comment>();
  DatabaseService db;
  StorageReference imagesReference = FirebaseStorage.instance.ref().child("images");
  Uint8List imageFile;
  String newComment = '';
  String error = '';
  int likeCount = 0;
  bool isLikedByUser = false;
  DocumentReference likeReference;

  Future comment(String comment) async {
    return await db.createNewComment(widget.post.pid, comment);
  }

  Future addLike() async {
    likeReference = await db.addLike(widget.post.pid);
    widget.onRefresh();
    return likeReference;
  }

  Future deleteLike() async {
    await db.removeLike(widget.post.pid);
    await likeReference.delete();
    widget.onRefresh();
    return true;
  }

  Widget decideTileWidget() {
    if(imageFile == null) {
      return Center(child:Text("Loading"));
    } else {
      return Image.memory(imageFile, fit: BoxFit.cover);
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
      return Colors.white;
    }
  }

  Future deletePost() async {
    widget.onRefresh();
    await Firestore.instance.collection('posts').document(widget.post.pid).delete();
    return true;
  }

  Widget decideDeletePost() {
    if(widget.post.uid == widget.user.uid) {
      return RaisedButton(
          color: Colors.amber,
          child: Text(
            'Delete Post',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            dynamic result = await deletePost();
            if (result == false) {
              setState(() {
                error = 'Failed to delete post';
              });
            } else {
              setState(() {
                Navigator.pop(context);
              });
            }
          }
      );
    } else {
      return SizedBox(height: 2.0);
    }
  }

  void loadComments() {

    Firestore.instance
        .collection("comments")
        .where("pid", isEqualTo: widget.post.pid)
        .snapshots()
        .listen((snapshot) {
          int count = comments.length;
          for(int i = 0; i < snapshot.documents.length; i++) {
            DocumentSnapshot f = snapshot.documents[i];
            if(count > 0) {
              int j;
              for(j = 0; j < comments.length; j++) {
                if(f.documentID == comments[j].cid) {
                  count--;
                  break;
                }
              }
              if(j == comments.length) {
                setState((){
                  comments.add(new Comment(f.documentID, f.data['uid'], f.data['email'], f.data['pid'], f.data['comment']));
                });
              }
            } else {
              setState((){
                comments.add(new Comment(f.documentID, f.data['uid'], f.data['email'], f.data['pid'], f.data['comment']));
              });
            }
          }
    });
    print("Comment");

  }

  @override
  void initState() {
    super.initState();
    loadComments();
    loadLikes(widget.user);
    if(!imageData.containsKey(widget.post.pid)){
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
          value: 1,
          child: Text("Delete post")
      );
    else return null;
  }

  @override
  Widget build(BuildContext context) {

    db = new DatabaseService(user: widget.user);

    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        title: Text('Zokky'),
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
        actions: <Widget>[],
      ),
      body: new ListView(
        children:<Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("A"),
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.white,),
                elevation: 3.2,
                onSelected: (value) async {
                  if(value == 1) {
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
                                  Navigator.pop(context);
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
                  decideMenuItem()
                ],
              )
            ],
          ),
          new Container(
            padding: EdgeInsets.only(left: 8.0, top: 10.0),
            child: Text(widget.post.title,
                style: TextStyle(fontSize: 25, color: Colors.white)),
          ),
          decideTileWidget(),
          new Row(
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
                      color: Colors.grey[850],
                      child: Text('Like',
                          style: TextStyle(fontSize: 18, color: Colors.white))
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 20.0),
            child: Text("Add a comment:",
                style: TextStyle(fontSize: 18)
            ),
          ),
          TextFormField(
              decoration: textInputDecoration.copyWith(
                  hintText: 'Insert comment'),
              validator: (val) =>
              val.isEmpty
                  ? 'Comment empty'
                  : null,
              onChanged: (val) {
                setState(() => newComment = val);
              }
          ),
          SizedBox(height: 10.0),
          RaisedButton(
              color: Colors.grey[850],
              child: Text(
                'Add comment',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                  dynamic result = await comment(
                      newComment);
                  if (result == null) {
                    setState(() {
                      error = 'Failed to add comment';
                    });
                  } else {
                    setState(() {
                      error = 'Comment added succesfully';
                    });
                  }
                }
          ),
          SizedBox(height: 12.0),
          Text(
            error,
            style: TextStyle(color: Colors.yellow[400], fontSize: 15.0),
          ),
           Padding(
             padding: const EdgeInsets.only(left: 5.0, top: 10.0),
             child: Text("Comments (" + comments.length.toString() + ")",
                    style: TextStyle(fontSize: 18, color: Colors.white)
                  ),
           ),
           const Divider(
                  thickness: 2.0,
                  color:Colors.white
                ),
          new ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child:Text(comments[index].email +':',
                              style: TextStyle(fontSize: 18, color: Colors.white)
                            )
                        ),
                        new Container(
                          padding: EdgeInsets.only(left: 10.0, top: 10.0),
                          child: Text(comments[index].comment,
                              style: TextStyle(fontSize: 18, color: Colors.white)
                          )
                        ),
                        const Divider(
                            thickness: 1.0,
                            color:Colors.white
                        )
                      ],
                    );

                },
              ),


          ],
      ),

    );

  }
}
