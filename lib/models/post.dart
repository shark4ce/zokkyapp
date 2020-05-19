class Post implements Comparable<Post>{
  String pid;
  String title;
  String description;
  String uid;
  String fileExtension;
  DateTime timestamp;
  int likes;
  Duration timeDifference;

  Post(pid, title, description, uid, fileExtension, timestamp, likes) {
    this.pid = pid;
    this.title = title;
    this.description = description;
    this.uid = uid;
    this.fileExtension = fileExtension;
    this.timestamp = timestamp;
    this.likes = likes;

    this.timeDifference = DateTime.now().difference(timestamp);
  }

  int compareTo(Post post) {
    return (100 *post.likes + 1) ~/ (post.timeDifference.inDays+1) - (100*this.likes + 1) ~/ (this.timeDifference.inDays+1);
  }
}