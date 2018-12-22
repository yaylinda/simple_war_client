import 'package:flutter/material.dart';
import 'package:simple_war_client/models/game_card.dart';
import 'package:simple_war_client/screens/game_screen.dart';

class HandScreen extends StatelessWidget {

  final List<GameCard> hand;
  final List<bool> isSelectedList;
  final GameScreenState parentState;

  HandScreen({
    this.hand,
    this.isSelectedList,
    this.parentState,
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
            isSelected: this.isSelectedList[handIndex],
            parentScreen: this,
          );
        }).toList(),
      ),
    );
  }

  void updateSelectedCard(int handIndexToUpdate, bool isSelected) {
    this.parentState.updatedSelectedCard(handIndexToUpdate, isSelected ? this.hand[handIndexToUpdate] : null);
  }
}

class HandCardScreen extends StatelessWidget {

  final GameCard gameCard;
  final int handIndex;
  final bool isSelected;
  final HandScreen parentScreen;

  HandCardScreen({
    this.gameCard,
    this.handIndex,
    this.isSelected,
    this.parentScreen,
  });

  @override
  Widget build(BuildContext context) {
    IconData cardIcon = this.gameCard.type == "TROOP" ? Icons.people : Icons
        .domain;

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: this.isSelected ? Border.all(color: Colors.lightBlueAccent) : Border.all(color: Colors.grey),
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
        ),
      ),
      onTap: () {
        if (this.parentScreen.parentState.game.currentTurn) {
          print("tapped... handIndex: ${this.handIndex} - ${this.gameCard.type}");
          this.parentScreen.updateSelectedCard(
              this.handIndex, !this.isSelected);
        }
      },
    );
  }
}
