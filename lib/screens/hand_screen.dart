import 'package:flutter/material.dart';
import 'package:simple_war_client/models/game_card.dart';
import 'package:simple_war_client/screens/game_screen.dart';

class HandScreen extends StatefulWidget {

  final List<GameCard> hand;
  final GameScreenState parentState;

  HandScreen({
    this.hand,
    this.parentState,
  });

  @override
  HandScreenState createState() =>
      HandScreenState(
        hand: this.hand,
        parentState: this.parentState,
        isSelectedList: List.filled(this.hand.length, false),
      );
}

class HandScreenState extends State<HandScreen> {

  List<GameCard> hand;
  List<bool> isSelectedList;
  GameScreenState parentState;
  
  HandScreenState({
    this.hand,
    this.parentState,
    this.isSelectedList,
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
            parentState: this,
          );
        }).toList(),
      ),
    );
  }
  
  void updateSelectedCard(int handIndexToUpdate, bool isSelected) {
    setState(() {
      this.isSelectedList = List.filled(this.hand.length, false);
      this.isSelectedList[handIndexToUpdate] = isSelected;
    });
    this.parentState.updatedSelectedCard(isSelected ? this.hand[handIndexToUpdate] : null);
  }
}

class HandCardScreen extends StatelessWidget {

  final GameCard gameCard;
  final int handIndex;
  final bool isSelected;
  final HandScreenState parentState;

  HandCardScreen({
    this.gameCard,
    this.handIndex,
    this.isSelected,
    this.parentState,
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
        if (this.parentState.parentState.game.currentTurn) {
          print(
              "tapped... handIndex: ${this.handIndex} - ${this.gameCard.type}");
          this.parentState.updateSelectedCard(
              this.handIndex, !this.isSelected);
        }
      },
    );
  }
}
