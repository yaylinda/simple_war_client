import 'package:simple_war_client/models/game_card.dart';

class Cell {

  String state;
  GameCard gameCard;

  Cell({
    this.state,
    this.gameCard,
  });

  factory Cell.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return Cell(
      state: json["state"],
      gameCard: GameCard.fromJSON(json["card"]),
    );
  }

}
