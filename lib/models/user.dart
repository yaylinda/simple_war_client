class User {

  String _token;
  String _username;

  User(this._token, this._username);

  User.map(dynamic obj) {
    this._token = obj["token"];
    this._username = obj["username"];
  }

  String get token => _token;
  String get username => _username;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["token"] = _token;
    map["username"] = _username;
    return map;
  }
}