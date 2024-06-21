class UserModel  {
  String? username;
  String? useremail;
  String? userid;

  String? userimage;
  int? followers;
  int? following;

  UserModel({
    this.username,
    this.useremail,
    this.userid,
    this.userimage,
    this.followers,
    this.following,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['name'];
    useremail = json['email'];
    userid = json['id'];
    userimage = json['userimage'];
    followers = json['followers'];
    following = json['following'];
  }

  Map<String, dynamic> tojson() {
    return {
      'name': username,
      'email': useremail,
      'id': userid,
      'userimage': userimage,
      'followers': followers,
      'following': following,
    };
  }
}
