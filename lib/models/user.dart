class User {

  String token;
  String username;
  String email;

  User({
    this.token, 
    this.username, 
    this.email,
  });

  factory User.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return User(
      token: json["token"],
      username: json["username"],
      email: json["email"],
    );
  }
}