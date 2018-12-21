import 'package:flutter/material.dart';
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

  GameScreenState({
    this.game
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Simple War")),
      body: Column(
        children: <Widget>[
          GameInfoScreen(
              game: this.game,
              navigateOnClick: false,
          ),
          GameStatScreen(
            game: this.game,
          ),
          GameBoardScreen(
              game: this.game
          ),
          HandScreen(
            hand: this.game.cards
          ),
          ButtonScreen(
            username: this.game.username,
          )
        ],
      ),
      backgroundColor: Colors.lightBlueAccent,
    );
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
            api.getGameByIdAndUsername(this.game.id, this.game.username)
                .then((game) {
              print("retrieved game with id=${game.id}");
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) =>
                      GameScreen(game: game)));
            });
          }
        },
      ),
    );
  }
}

class GameStatScreen extends StatelessWidget {

  final Game game;

  GameStatScreen({
    this.game
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "Game Stats",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text("Energy Remaining: ${game.energy}\nNumber of Turns: ${game.numTurns}"),
            leading: Icon(
                Icons.insert_chart,
                color: Colors.blue
            ),
            trailing: Icon(
              Icons.insert_chart,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

}

class GameBoardScreen extends StatelessWidget {

  final Game game;

  GameBoardScreen({
    this.game
  });

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

    return Card(
      child: Column(
        children: this.game.board.map((row) {
          int rowNum = this.game.board.indexOf(row);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((c) {
              int colNum = row.indexOf(c);
              return CellScreen(
                cell: c,
                username: this.game.username,
                row: rowNum,
                col: colNum,
              );
            }).toList(),
          );
        }).toList(),
      )
    );
  }

}

class CellScreen extends StatelessWidget {

  final Cell cell;
  final String username;
  final int row;
  final int col;

  CellScreen({
    this.cell,
    this.username,
    this.row,
    this.col,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: GameCardScreen(
          gameCard: this.cell.gameCard,
          username: this.username,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        margin: EdgeInsets.only(
          top: 6.0,
          bottom: 6.0,
          left: 6.0,
          right: 6.0,
        ),
      ),
      onTap: () {
        print("tapped... row:${this.row}, col:${this.col} - ${this.cell.state}");
      },
    );

  }
}

class GameCardScreen extends StatelessWidget {

  final GameCard gameCard;
  final String username;

  GameCardScreen({
    this.gameCard,
    this.username
  });

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

    IconData cardIcon = this.gameCard.type == "TROOP" ? Icons.people : Icons.domain;
    MaterialColor cardIconColor = this.gameCard.owner == this.username ? Colors.green : Colors.red;

    return Row(
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
                ),
            ),
          ],
        )
      ],
    );
  }
}

class HandScreen extends StatelessWidget {

  final List<GameCard> hand;

  HandScreen({
    this.hand,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: hand.map((c) {
          int handIndex = hand.indexOf(c);
          return HandCardScreen(
            gameCard: c,
            handIndex: handIndex,
          );
        }).toList(),
      ),
    );
  }

}

class HandCardScreen extends StatelessWidget {

  final GameCard gameCard;
  final int handIndex;

  HandCardScreen({
    this.gameCard,
    this.handIndex,
  });

  @override
  Widget build(BuildContext context) {

    IconData cardIcon = this.gameCard.type == "TROOP" ? Icons.people : Icons.domain;

    return GestureDetector(
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          margin: EdgeInsets.only(
            top: 6.0,
            bottom: 6.0,
            left: 3.0,
            right: 3.0,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    cardIcon,
                    color: Colors.green,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.radio_button_checked,
                    color: Colors.blueGrey,
                  ),
                  Text(
                    "${this.gameCard.might}",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.monetization_on,
                    color: Colors.blueGrey,
                  ),
                  Text(
                    "${this.gameCard.cost}",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
      onTap: () {
        print("tapped... handIndex: ${this.handIndex} - ${this.gameCard.type}");
      },
    );
  }
}

class ButtonScreen extends StatelessWidget {

  final String username;

  ButtonScreen({
    this.username
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Commit Card and End Turn"),
            onPressed: () {
              print("pressed Commit Cards and End Turn");
            },
          ),
          RaisedButton(
            child: Text("Discard Hand and End Turn"),
            onPressed: () {
              print("pressed Discard Hand and End Turn");
            },
          )
        ],
      ),
    );
  }
}