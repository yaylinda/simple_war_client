import 'package:flutter/material.dart';
import 'package:simple_war_client/home_screen.dart';
import 'package:simple_war_client/models/cell.dart';
import 'package:simple_war_client/models/game.dart';
import 'package:simple_war_client/models/game_card.dart';
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
//        body: Text("${game.id}"),
        body: Center(
          child: Column(
            children: <Widget>[
              GameInfoCard(
                  game: this.game,
                  navigateOnClick: false,
              ),
              GameBoardScreen(game: this.game),
            ],
          ),
        ),
    );
  }
}

class GameBoardScreen extends StatelessWidget {

  final Game game;

  GameBoardScreen({this.game});

  @override
  Widget build(BuildContext context) {

    print("build GameBoardScreen...");

    // flatMap List<List<Cell>> into List<Cell>
    List<Cell> cells = List();
    for (List<Cell> row in this.game.board) {
      for (Cell cell in row) {
        cells.add(cell);
      }
    }

    return Column(
      children: this.game.board.map((row) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((c) {
              return CellScreen(
                  cell: c,
                  username: this.game.username);
            }).toList());
      }).toList(),
    );
  }

}

class CellScreen extends StatelessWidget {

  final Cell cell;
  final String username;

  CellScreen({this.cell, this.username});

  @override
  Widget build(BuildContext context) {
    print("build CellScreen...");

    return Container(
      child: GameCardScreen(
        gameCard: this.cell.gameCard,
        username: this.username,),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
      ),
    );
  }

}

class GameCardScreen extends StatelessWidget {

  final GameCard gameCard;
  final String username;

  GameCardScreen({this.gameCard, this.username});

  @override
  Widget build(BuildContext context) {

    double cardIconSize = 72.0;

    if (this.gameCard == null) {
      return Container(
        child: Icon(
          Icons.crop_square,
          color: Colors.grey,
          size: cardIconSize
        ),
      );
    }

    IconData cardIcon = this.gameCard.type == "TROOP" ? Icons.people : Icons.location_city;
    MaterialColor cardIconColor = this.gameCard.owner == this.username ? Colors.green : Colors.red;

    return Container(
      child: Row(
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Icon(
                cardIcon,
                color: cardIconColor,
                size: cardIconSize,
              ),
              Icon(
                Icons.radio_button_checked,
                color: Colors.blueGrey,
                size: 48.0,
              ),
              Text(
                  "${this.gameCard.might}",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                  )
              )
            ],
          )
        ],
      ),
    );
  }
}