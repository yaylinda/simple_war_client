import 'package:simple_war_client/models/card.dart';

class Cell {

  String _state;
  Card _card;

  Cell(this._state, this._card);

  Card get card => _card;
  String get state => _state;

  Cell.map(dynamic obj) {
    this._state = obj["state"];
    this._card = Card.map(obj["card"]);
  }

}
