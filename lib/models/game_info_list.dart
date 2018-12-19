import 'package:simple_war_client/models/game_info.dart';

class GameInfoList {

  List<GameInfo> _games;

  GameInfoList(this._games);

  List<GameInfo> get games => _games;

  GameInfoList.map(List<dynamic> parsedJson) {
    this._games = parsedJson.map((json) => GameInfo.map(json)).toList();
  }
}