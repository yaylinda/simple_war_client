class Card {

  String type;
  int might;
  int movement;
  double cost;
  String owner;
  int numTurnsOnBoard;
  String specialAbility; // TODO v2

  Card({
    this.type,
    this.might,
    this.movement,
    this.cost,
    this.owner,
    this.numTurnsOnBoard,
    this.specialAbility,
  });

  factory Card.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return Card(
      type: json["type"],
      might: json["might"],
      movement: json["movement"],
      cost: json["cost"],
      owner: json["owner"],
      numTurnsOnBoard: json["numTurnsOnBoard"],
      specialAbility: json["specialAbility"],
    );
  }

}
