class User {

  String _token;
  String _username;
  String _email;

  User(this._token, this._username, this._email);

  User.map(dynamic obj) {
    this._token = obj["token"];
    this._username = obj["username"];
    this._email = obj["email"];
  }

  String get token => _token;
  String get username => _username;
  String get email => _email;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["token"] = _token;
    map["username"] = _username;
    map["email"] = _email;
    return map;
  }
}