import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zokkyapp/models/post.dart';
import 'package:zokkyapp/screens/home/data_holder.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final int index;
  PostTile({this.post, this.index});
  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {

  StorageReference imagesReference = FirebaseStorage.instance.ref().child("images");
  Uint8List imageFile;

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
                  child: Text("10 Likes",
                      style: TextStyle(fontSize: 18)),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        onPressed: (){},
                        color: Colors.amber,
                        child: Text('Like',
                            style: TextStyle(fontSize: 18))
                    ),
                    FlatButton(
                        onPressed: (){},
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