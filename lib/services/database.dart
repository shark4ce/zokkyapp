import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService ({ this.uid });

  final CollectionReference postCollection = Firestore.instance.collection('posts');

  Future createNewPost(String title, String description, String fileExtension) async {
    DocumentReference ref = await postCollection
        .add({
      'title': title,
      'description': description,
      'uid': uid,
      'fileExtension': fileExtension
    });
    print(ref.documentID);
    return ref;
  }

  Future modifyPost(String postId, String title, String description, String fileExtension) async {
    return await postCollection.document(postId)
        .setData({
      'title': title,
      'description': description,
      'uid': uid,
      'fileExtension': fileExtension
    });
  }
}