import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zokkyapp/models/user.dart';

class DatabaseService {

  final User user;

  DatabaseService({ this.user });

  final CollectionReference postCollection = Firestore.instance.collection(
      'posts');
  final CollectionReference commentCollection = Firestore.instance.collection(
      'comments');
  final CollectionReference likesCollection = Firestore.instance.collection(
      'likes');


  Future createNewPost(String title, String description,
      String fileExtension) async {
    DocumentReference ref = await postCollection
        .add({
      'title': title,
      'description': description,
      'uid': user.uid,
      'fileExtension': fileExtension,
      'timestamp': new DateTime.now(),
      'likes': 0
    });
    print(ref.documentID);
    return ref;
  }

  Future modifyPost(String postId, String title, String description,
      String fileExtension) async {
    return await postCollection.document(postId)
        .setData({
      'title': title,
      'description': description,
      'uid': user.uid,
      'fileExtension': fileExtension,
      'timestamp': new DateTime.now(),
      'likes': 0
    });
  }

  Future createNewComment(String pid, String comment) async {
    DocumentReference ref = await commentCollection
        .add({
      'pid': pid,
      'uid': user.uid,
      'email': user.email,
      'comment': comment
    });

    return ref;
  }

  Future addLike(String pid) async {
    DocumentReference ref = await likesCollection
        .add({
      'pid': pid,
      'uid': user.uid,
    });
    await postCollection.document(pid).updateData({
      'likes': FieldValue.increment(1)
    });
    return ref;
  }

  Future removeLike(String pid) async {
    await postCollection.document(pid).updateData({
      'likes': FieldValue.increment(-1)
    });

  }
}