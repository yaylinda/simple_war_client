import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_war_client/screens/game_screen.dart';
import 'package:simple_war_client/models/game.dart';
import 'package:simple_war_client/service/rest_ds.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({
    this.username,
  });

  @override
  HomeScreenState createState() => new HomeScreenState(username: this.username);
}

class HomeScreenState extends State<HomeScreen> {
  final RestDatasource api = new RestDatasource();
  String username;
  List<Game> gameInfoList = List();
  int timesCalled = 0;

  HomeScreenState({
    this.username,
  });

  @override
  void initState() {
    super.initState();

    print("***** initing home screen");
    if (this.username == null) {
      print("username in HomeScreen initState is null...");
      this.getUsername().then((value) {
        this.username = value;
        print("retrieved username: ${this.username}, from SharedPrefs");
        api.getGamesForUser(this.username).then((result) {
          print("initState... got games list for user");
          setState(() {
            this.gameInfoList = result;
          });
        });
      });
    } else {
      api.getGamesForUser(this.username).then((result) {
        print("initState... got games list for user");
        setState(() {
          this.gameInfoList = result;
        });
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    this.timesCalled++;
    print("HomeScreenState build is called... ${this.timesCalled}");

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
          ],
        ),
      ),
      body: GameListScreen(
        gameInfoList: this.gameInfoList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          api.startGame(this.username).then((game) {
            print("created game with id=${game.id}");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => GameScreen(game: game)));
          });
        },
        tooltip: "Create new game",
        child: Icon(Icons.add),
      ),
    );
  }

  Future<String> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("username") ?? '';
  }

  Future<bool> setUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("username", username);
  }
}

class GameListScreen extends StatelessWidget {
  final List<Game> gameInfoList;

  GameListScreen({
    this.gameInfoList,
  });

  @override
  Widget build(BuildContext context) {
    print("GameListScreen build is called... ${gameInfoList.length} games");

    return ListView.builder(
        itemCount: gameInfoList.length,
        itemBuilder: (BuildContext context, int index) {
          return GameInfoScreen(
            game: gameInfoList[index],
            navigateOnClick: true,
          );
        });
  }
}

class GameInfoScreen extends StatelessWidget {

  final RestDatasource api = new RestDatasource();
  final Game game;
  final bool navigateOnClick;

  GameInfoScreen({
    this.game,
    this.navigateOnClick
  });

  @override
  Widget build(BuildContext context) {

    String opponentName = this.game.opponentName == null ? "<TBD>" : this.game.opponentName;

    return Card(
      child: ListTile(
        title: Text(
          "Simple War against ${opponentName}",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
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
          if (this.navigateOnClick) {
            api.getGameByIdAndUsername(this.game.id, this.game.username).then((game) {
              print("retrieved game with id=${game.id}");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => GameScreen(game: game)));
            });
          }
        },
      ),
    );
  }
}
