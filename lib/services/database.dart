import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService ({ this.uid });

  final CollectionReference postCollection = Firestore.instance.collection('posts');

  Future createNewPost(String title, String description, String imageName) async {
    DocumentReference ref = await postCollection
        .add({
      'title': title,
      'description': description,
      'uid': uid,
      'imageName': imageName
    });
    print(ref.documentID);
  }
}