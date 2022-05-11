class SocialUserModel {
  String name;
  String email;
  String phone;
  String uId;
  String image;
  bool isEmailVerified;
  String bio;
  String cover;
  String token;

  //constructor
  SocialUserModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.isEmailVerified,
    this.image,
    this.bio,
    this.cover,
    this.token,
  });
//namedConstructor
  SocialUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    bio = json['bio'];
    cover = json['cover'];
    token = json['token'];
    isEmailVerified = json['isEmailVerified'];
  }
//toMap

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'isEmailVerified': isEmailVerified,
      'image': image,
      'bio': bio,
      'cover': cover,
      'token': token,
    };
  }
}
