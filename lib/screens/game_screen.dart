import 'package:flutter/material.dart';
import 'package:simple_war_client/models/cell.dart';
import 'package:simple_war_client/models/game.dart';
import 'package:simple_war_client/models/game_card.dart';
import 'package:simple_war_client/screens/button_screen.dart';
import 'package:simple_war_client/screens/hand_screen.dart';
import 'package:simple_war_client/screens/home_screen.dart';
import 'package:simple_war_client/service/rest_ds.dart';

class GameScreen extends StatefulWidget {

  final Game game;

  GameScreen({
    this.game,
  });

  @override
  GameScreenState createState() => GameScreenState(game: game);
}

class GameScreenState extends State<GameScreen> {

  final RestDatasource api = new RestDatasource();
  Game game;
  GameCard selectedCard;
  int selectedCardIndex;

  GameInfoScreen gameInfoScreen;
  GameStatScreen gameStatScreen;
  GameBoardScreen gameBoardScreen;
  HandScreen handScreen;
  ButtonScreen buttonScreen;

  GameScreenState({
    this.game
  });

  @override
  void initState() {
    super.initState();
    print("***** initing game screen ");
    this.createChildWidgets(this.game, List.filled(this.game.cards.length, false));
  }

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
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      HomeScreen(username: this.game.username)));
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            gameInfoScreen,
            gameStatScreen,
            gameBoardScreen,
            handScreen,
            buttonScreen,
          ],
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }

  void updatedSelectedCard(int selectedCardIndex, GameCard selectedCard) {
    print("update selected card of gamestate to $selectedCard, selectedCardIndex=$selectedCardIndex");
    this.selectedCard = selectedCard;
    this.selectedCardIndex = selectedCardIndex;

    List<bool> isSelectedList = List.filled(this.game.cards.length, false);

    if (selectedCard != null) {
      isSelectedList[selectedCardIndex] = true;
    }

    setState(() {
      this.handScreen = HandScreen(
        hand: this.game.cards,
        isSelectedList: isSelectedList,
        parentState: this,
      );
    });
  }

  void updateStateWithNewGame(Game game) {
    print("updating GameScreenState with new game...");
    setState(() {
      this.game = game;
      this.createChildWidgets(game, List.filled(this.game.cards.length, false));
    });
  }

  void createChildWidgets(Game game, List<bool> isSelectedList) {
    print("creating child widgets");

    this.gameInfoScreen = GameInfoScreen(
      game: game,
      navigateOnClick: false,
    );

    this.gameStatScreen = GameStatScreen(
      game: game,
      parentState: this,
    );

    this.gameBoardScreen = GameBoardScreen(
      game: game,
      parentState: this,
    );

    this.handScreen = HandScreen(
      hand: game.cards,
      isSelectedList: isSelectedList,
      parentState: this,
    );

    this.buttonScreen = ButtonScreen(
      gameId: game.id,
      username: game.username,
      isEnabled: game.currentTurn,
      parentState: this,
    );
  }
}

class GameStatScreen extends StatelessWidget {

  final Game game;
  final GameScreenState parentState;

  GameStatScreen({
    this.game,
    this.parentState,
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
            subtitle: Text(
                "Energy Remaining: ${game.energy}\nNumber of Turns: ${game
                    .numTurns}"),
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
  final GameScreenState parentState;

  GameBoardScreen({
    this.game,
    this.parentState,
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
                  parentState: this.parentState,
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
  final GameScreenState parentState;

  CellScreen({
    this.cell,
    this.username,
    this.row,
    this.col,
    this.parentState,
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
        print("current gamestate selected card: ${this.parentState.selectedCard}");
        if (this.parentState.selectedCard != null) {
          this.parentState.api.putCardByIdAndUsername(this.parentState.game.id, this.parentState.game.username, this.row, this.col, this.parentState.selectedCard).then((response) {
            this.parentState.selectedCard = null;
            this.parentState.updateStateWithNewGame(response.game);
            if (response.status == "SUCCESSFUL") {
              print("got updated game after put card");
            } else {
              print("invalid put card placement: '${response.message}'");
              // TODO: show error message to user
            }
          });
        }
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

    IconData cardIcon = this.gameCard.type == "TROOP" ? Icons.people : Icons
        .domain;
    MaterialColor cardIconColor = this.gameCard.owner == this.username ? Colors
        .green : Colors.red;

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
