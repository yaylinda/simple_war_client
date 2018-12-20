import 'package:simple_war_client/models/card.dart';
import 'package:simple_war_client/models/cell.dart';

class Game {

  String id;
  String username;
  String opponentName;
  bool currentTurn;
  int points;
  double energy;
  String status;
  int numTurns;
  int opponentPoints;
  int numCardsPlayed;
  int numRows;
  int numCols;
  List<Card> cards;
  List<List<Cell>> board;
  List<List<Cell>> previousBoard;

  Game({
    this.id,
    this.username,
    this.opponentName,
    this.currentTurn,
    this.points,
    this.energy,
    this.status,
    this.numTurns,
    this.opponentPoints,
    this.numCardsPlayed,
    this.numRows,
    this.numCols,
    this.cards,
    this.board,
    this.previousBoard,
  });
  
  factory Game.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    List<dynamic> rows;

    List<List<Cell>> parsedBoard = new List();
    rows = (json["board"] as List);
    for (dynamic row in rows) {
      List<Cell> cells = (row as List).map((i) => Cell.fromJSON(i)).toList();
      parsedBoard.add(cells);
    }

    List<List<Cell>> parsedPreviousBoard = new List();
    rows = (json["previousBoard"] as List);
    for (dynamic row in rows) {
      List<Cell> cells = (row as List).map((i) => Cell.fromJSON(i)).toList();
      parsedPreviousBoard.add(cells);
    }

    return Game(
      id: json["id"],
      username: json["username"],
      opponentName: json["opponentName"],
      currentTurn: json["currentTurn"],
      points: json["points"],
      energy: json["energy"],
      status: json["status"],
      numTurns: json["numTurns"],
      opponentPoints: json["opponentPoints"],
      numCardsPlayed: json["numCardsPlayed"],
      numRows: json["numRows"],
      numCols: json["numCols"],
      cards: (json["cards"] as List).map((i) => Card.fromJSON(i)).toList(),
      board: parsedBoard,
      previousBoard: parsedPreviousBoard,
    );
  }
}