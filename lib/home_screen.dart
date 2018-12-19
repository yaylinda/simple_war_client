import 'package:flutter/material.dart';
import 'package:simple_war_client/models/game_info.dart';
import 'package:simple_war_client/models/game_info_list.dart';
import 'package:simple_war_client/rest_ds.dart';

class HomeScreen extends StatelessWidget {

  final RestDatasource api = new RestDatasource();
  final String username;

  HomeScreen({this.username});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(title: new Text("$username's Simple War")),
        body: FutureBuilder(
            future: api.getGamesForUser(username),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return snapshot.hasData
                  ? GameListScreen(gameInfoList: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            })
    );
  }
}

class GameListScreen extends StatelessWidget {

  final GameInfoList gameInfoList;

  GameListScreen({this.gameInfoList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: gameInfoList.games.length,
        itemBuilder: (BuildContext context, int index) {
          return new GameInfoCard(game: gameInfoList.games[index]);
        });
  }
}

class GameInfoCard extends StatelessWidget {

  final GameInfo game;

  GameInfoCard({this.game});

  @override
  Widget build(BuildContext context) {
    return new Text("Game against ${game.opponentName} | Score: ${game.points} vs. ${game.opponentPoints}");
  }
}