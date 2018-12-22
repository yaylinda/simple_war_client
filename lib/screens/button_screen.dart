import 'package:flutter/material.dart';
import 'package:simple_war_client/screens/game_screen.dart';
import 'package:simple_war_client/service/rest_ds.dart';

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
        api.endTurnByIdAndUsername(this.gameId, this.username, discardHand)
            .then((game) {
          print("got updated game after pressing end turn");
          this.parentState.updateStateWithNewGame(game, true, false, false);
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