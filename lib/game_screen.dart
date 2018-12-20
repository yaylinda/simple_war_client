import 'package:flutter/material.dart';
import 'package:simple_war_client/models/game.dart';
import 'package:simple_war_client/rest_ds.dart';

class GameScreen extends StatefulWidget {

  final Game game;

  GameScreen({this.game});

  @override
  GameScreenState createState() => new GameScreenState(game: game);

}

class GameScreenState extends State<GameScreen> {

  final RestDatasource api = new RestDatasource();
  Game game;

  GameScreenState({this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Simple War")),
        body: Text("${game.id}")
    );
  }

}