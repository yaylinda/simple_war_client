class GameCard {

  String type;
  int might;
  int movement;
  double cost;
  String owner;
  int numTurnsOnBoard;
  String specialAbility; // TODO v2

  GameCard({
    this.type,
    this.might,
    this.movement,
    this.cost,
    this.owner,
    this.numTurnsOnBoard,
    this.specialAbility,
  });

  factory GameCard.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return GameCard(
      type: json["type"],
      might: json["might"],
      movement: json["movement"],
      cost: json["cost"],
      owner: json["owner"],
      numTurnsOnBoard: json["numTurnsOnBoard"],
      specialAbility: json["specialAbility"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': this.type,
      'might': this.might,
      'movement': this.movement,
      'cost': this.cost,
      'owner': this.owner,
      'numTurnsOnBoard': this.numTurnsOnBoard,
      'specialAbility': this.specialAbility,
    };
  }

}
