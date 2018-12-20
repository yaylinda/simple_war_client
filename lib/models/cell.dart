import 'package:simple_war_client/models/card.dart';

class Cell {

  String state;
  Card card;

  Cell({
    this.state,
    this.card,
  });

  factory Cell.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return Cell(
      state: json["state"],
      card: Card.fromJSON(json["card"]),
    );
  }

}
