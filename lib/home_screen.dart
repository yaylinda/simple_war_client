import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_war_client/game_screen.dart';
import 'package:simple_war_client/models/game.dart';
import 'package:simple_war_client/rest_ds.dart';

class HomeScreen extends StatelessWidget {

  final RestDatasource api = new RestDatasource();
  final String username;

  HomeScreen({this.username});

  Future<bool> setUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("username", username);
  }

  @override
  Widget build(BuildContext context) {
    print("HomeScreen build is called");
    return Scaffold(
        appBar: AppBar(title: Text("Simple War")),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Menu'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    setUsername("").then((result) {
                      print("logging out...");
                      Navigator.popAndPushNamed(context, "/");
                    });
                  },
                )
              ]
          )
        ),
        body: FutureBuilder(
            future: api.getGamesForUser(username),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return snapshot.hasData
                  ? GameListScreen(gameInfoList: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            api.startGame(username).then((game) {
              print("created game with id=${game.id}");
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GameScreen(game: game)));
            });
          },
          tooltip: "Create new game",
          child: Icon(Icons.add))
    );
  }
}

class GameListScreen extends StatelessWidget {

  final List<Game> gameInfoList;

  GameListScreen({this.gameInfoList});

  @override
  Widget build(BuildContext context) {
    print("GameListScreen build is called...");
    print(gameInfoList.length);

    return ListView.builder(
        itemCount: gameInfoList.length,
        itemBuilder: (BuildContext context, int index) {
          return GameInfoCard(game: gameInfoList[index]);
        });
  }
}

class GameInfoCard extends StatelessWidget {

  final RestDatasource api = new RestDatasource();
  final Game game;

  GameInfoCard({this.game});

  @override
  Widget build(BuildContext context) {
//    return Text("Game against ${game.opponentName} | Score: ${game.points} vs. ${game.opponentPoints} | My turn: ${game.currentTurn} | Status: ${game.status}");
    String opponentName = this.game.opponentName == null ? "<TBD>" : this.game.opponentName;

    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Simple War against ${opponentName}", style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text("Score: ${this.game.points} vs. ${this.game.opponentPoints}\nStatus: ${game.status}"),
            leading: Icon(
              Icons.blur_linear,
              color: Colors.blue
            ),
            trailing: Icon(
              Icons.videogame_asset,
              color: game.currentTurn ? Colors.green : Colors.red,
            ),
            onTap: () {
              api.getGameByIdAndUsername(this.game.id, this.game.username).then((game) {
                print("retrieved game with id=${game.id}");
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GameScreen(game: game)));
              });
            },
          ),
        ],
      ),
    );
  }
}