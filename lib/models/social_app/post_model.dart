class PostModel {
  String image;
  String name;
  String uId;
  String postId;
  String dateTime;
  String text;
  String imagePost;
  int like;
  int comment;

// constructor
  PostModel({
    this.image,
    this.name,
    this.uId,
    this.postId,
    this.dateTime,
    this.text,
    this.imagePost,
    this.like,
    this.comment,
  });

// named constructor

  PostModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    uId = json['uId'];
    dateTime = json['dateTime'];
    text = json['text'];
    imagePost = json['imagePost'];
    like = json['like'];
    postId = json['postId'];
    comment = json['comment'];
  }

// to map
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'uId': uId,
      'dateTime': dateTime,
      'text': text,
      'imagePost': imagePost,
      'like': like,
      'comment': comment,
      'postId': postId,
    };
  }
}
