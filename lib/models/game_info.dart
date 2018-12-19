class GameInfo {

  String _id;
  String _username;
  String _opponentName;
  bool _currentTurn;
  int _points;
  double _energy;
  String _status;
  int _numTurns;
  int _opponentPoints;
  int _numCardsPlayed;

  GameInfo(this._id, this._username, this._opponentName, this._currentTurn,
      this._points, this._energy, this._status, this._numTurns,
      this._opponentPoints, this._numCardsPlayed);

  String get id => _id;
  String get username => _username;
  String get opponentName => _opponentName;
  bool get currentTurn => _currentTurn;
  int get points => _points;
  double get energy => _energy;
  String get status => _status;
  int get numTurns => _numTurns;
  int get opponentPoints => _opponentPoints;
  int get numCardsPlayed => _numCardsPlayed;

  GameInfo.map(dynamic obj) {
    this._id = obj["id"];
    this._username = obj["username"];
    this._opponentName = obj["opponentName"];
    this._currentTurn = obj["currentTurn"];
    this._points = obj["points"];
    this._energy = obj["energy"];
    this._status = obj["status"];
    this._numTurns = obj["numTurns"];
    this._opponentPoints = obj["opponentPoints"];
    this._numCardsPlayed = obj["numCardsPlayed"];
  }
}