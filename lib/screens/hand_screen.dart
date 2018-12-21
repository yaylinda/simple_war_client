import 'package:flutter/material.dart';
import 'package:simple_war_client/models/game_card.dart';

class HandScreen extends StatefulWidget {

  final List<GameCard> hand;

  HandScreen({
    this.hand,
  });

  @override
  HandScreenState createState() =>
      HandScreenState(
        hand: this.hand,
        isSelectedList: List.filled(this.hand.length, false),
      );
}

class HandScreenState extends State<HandScreen> {

  List<GameCard> hand;
  List<bool> isSelectedList;
  
  HandScreenState({
    this.hand,
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
            parentHandState: this,
          );
        }).toList(),
      ),
    );
  }
  
  void updateSelectedCard(int handIndexToUpdate, bool isSelected) {
    setState(() {
      this.isSelectedList = List.filled(this.hand.length, false);
      this.isSelectedList[handIndexToUpdate] = isSelected;
      print("updating selected card status list...");
      print(this.isSelectedList);
    });
  }
}

class HandCardScreen extends StatelessWidget {

  final GameCard gameCard;
  final int handIndex;
  final bool isSelected;
  final HandScreenState parentHandState;

  HandCardScreen({
    this.gameCard,
    this.handIndex,
    this.isSelected,
    this.parentHandState,
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
        print("tapped... handIndex: ${this.handIndex} - ${this.gameCard.type}");
        this.parentHandState.updateSelectedCard(this.handIndex, !this.isSelected);
      },
    );
  }
}
