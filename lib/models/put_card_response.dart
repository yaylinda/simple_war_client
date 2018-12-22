import 'package:simple_war_client/models/game.dart';

class PutCardResponse {

  Game game;
  String status;
  String message;

  PutCardResponse({
    this.game,
    this.status,
    this.message,
  });

  factory PutCardResponse.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return PutCardResponse(
      game: Game.fromJSON(json["game"]),
      status: json["status"],
      message: json["message"],
    );
  }
}