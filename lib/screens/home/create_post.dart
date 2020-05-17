import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zokkyapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zokkyapp/services/auth.dart';
import 'package:zokkyapp/shared/constants.dart';
import 'package:zokkyapp/shared/loading.dart';
import 'package:zokkyapp/screens/home/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:zokkyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePost extends StatefulWidget {
  final Function toggleState;
  CreatePost({this.toggleState});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  final _formKey = GlobalKey<FormState>();
  static bool fileIsSelected = false;
  bool loading = false;

  //text field state
  String title = '';
  String description = '';
  File image;
  String error = '';
  DatabaseService db;
  FirebaseStorage _storage = FirebaseStorage.instance;


  Future post(String title, String description, File file) async {
    String fileName = basename(image.path);
    String fileExtension = fileName.substring(fileName.indexOf('.'));
    DocumentReference ref = await db.createNewPost(title, description, fileExtension);
    String newName = ref.documentID + fileExtension;
    StorageReference imagesReference = _storage.ref().child("images/$newName");
    StorageUploadTask uploadTask = imagesReference.putFile(image);
    return await uploadTask.onComplete;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    db = new DatabaseService(user: user);

    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Create Post'),
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.arrow_back),
              label: Text('Back'),
              onPressed: () {
                fileIsSelected = false;
                widget.toggleState(AppState.feed);
              }
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Upload image',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (image == null) {
                            setState(() {
                              loading = true;
                            });
                            await showDialog(
                              context:context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Please, upload an image!'),
                                  actions: <Widget>[
                                    FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          setState(() {
                                            loading = false;
                                          });
                                          Navigator.of(context).pop();
                                        }
                                    )
                                  ],
                                );
                              },
                            );
                          }else{
                            setState(() {
                              fileIsSelected = true;
                              error = 'Image uploaded';
                            });
                          }
                        }
                    ),
                    //title
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Title'),
                        validator: (val) =>
                        val.isEmpty
                            ? 'You must enter a title'
                            : null,
                        onChanged: (val) {
                          setState(() => title = val);
                        }
                    ),
                    //description
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Description'),
                        validator: (val) =>
                        val.length <= 0
                            ? 'You must enter a description'
                            : null,
                        onChanged: (val) {
                          setState(() => description = val);
                        }
                    ),
                    //Sign In Button
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Post',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate() && fileIsSelected) {
                            setState(() => loading = true);
                            dynamic result = await post(
                                title, description, image);
                            if (result == null) {
                              setState(() {
                                error = 'Upload failed';
                                loading = false;
                              });
                            } else {
                              widget.toggleState(AppState.feed);
                            }
                          }else {
                            String error;
                            if (fileIsSelected) {
                              error = 'Please, fill in the fields!';
                            }else {
                              error = 'Please, upload an image!';
                            }
                            await showDialog(
                              context:context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(error),
                                  actions: <Widget>[
                                    FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          setState(() {
                                            loading = false;
                                          });
                                          Navigator.of(context).pop();
                                        }
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        }
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 15.0),
                    ),
                  ],
                ),
              )
          )
      ),
    );
  }
}
