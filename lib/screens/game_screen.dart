import 'package:flutter/material.dart';
import 'package:simple_war_client/models/cell.dart';
import 'package:simple_war_client/models/game.dart';
import 'package:simple_war_client/models/game_card.dart';
import 'package:simple_war_client/screens/home_screen.dart';
import 'package:simple_war_client/service/rest_ds.dart';

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Simple War"),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen(username: this.game.username)));
            },
          ),
        ),
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
              game: this.game,
            ),
            HandScreen(
              hand: this.game.cards,
            ),
            ButtonScreen(
              gameId: this.game.id,
              username: this.game.username,
              isEnabled: this.game.currentTurn,
              parentState: this,
            )
          ],
        ),
        backgroundColor: Colors.lightBlueAccent,
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

  final RestDatasource api = new RestDatasource();
  final String gameId;
  final String username;
  final bool isEnabled;
  final GameScreenState parentState;

  ButtonScreen({
    this.gameId,
    this.username,
    this.isEnabled,
    this.parentState,
  });

  RaisedButton createEndTurnButton(String buttonText, bool discardHand) {
    return RaisedButton(
      child: Text(buttonText),
      onPressed: !this.isEnabled ? null : () {
        print("pressed $buttonText");
        api.endTurnByIdAndUsername(this.gameId, this.username, discardHand).then((game) {
          print("got updated game");
          this.parentState.setState(() {
            this.parentState.game = game;
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          createEndTurnButton("Commit Cards and End Turn", false),
          createEndTurnButton("Discard Hand and End Turn", true),
        ],
      ),
    );
  }
}