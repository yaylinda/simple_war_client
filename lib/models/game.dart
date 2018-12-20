import 'package:simple_war_client/models/card.dart';
import 'package:simple_war_client/models/cell.dart';

class Game {

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
  int _numRows;
  int _numCols;
  List<Card> _cards;
    List<List<Cell>> _board;
//  List<List<Cell>> _previousBoard;

  Game(this._id, this._username, this._opponentName, this._currentTurn,
      this._points, this._energy, this._status, this._numTurns,
      this._opponentPoints, this._numCardsPlayed, this._numRows, this._numCols,
      this._cards, this._board);

//  Game(this._id, this._username, this._opponentName, this._currentTurn,
//      this._points, this._energy, this._status, this._numTurns,
//      this._opponentPoints, this._numCardsPlayed, this._board,
//      this._previousBoard, this._cards);

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
  int get numRows => _numRows;
  int get numCols => _numCols;
  List<Card> get cards => _cards;
  List<List<Cell>> get board => _board;
//  List<List<Cell>> get previousBoard => _previousBoard;

  Game.map(dynamic obj) {
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
    this._numRows = obj["numRows"];
    this._numCols = obj["numCols"];
    this._cards = (obj["cards"] as List).map((i) => Card.map(i)).toList();
//    this._previousBoard = (obj["previousBoard"] as List).map((i) => (i as List).map((j) => Cell.map(j)).toList()).toList();

    List<List<Cell>> board = new List();
    List<dynamic> rows = (obj["board"] as List);
    for (dynamic row in rows) {
      List<Cell> cells = (row as List).map((i) => Cell.map(i)).toList();
      board.add(cells);
    }
    this._board = board;
  }

}