class Card {

  String type;
  int might;
  int movement;
  double cost;
  String owner;
  String specialAbility; // TODO v2
  int numTurnsOnBoard;

  Card({
    this.type,
    this.might,
    this.movement,
    this.cost,
    this.owner,
    this.specialAbility,
    this.numTurnsOnBoard});

  factory Card.map(dynamic obj) {
    if (obj == null) {
      return null;
    }
    return Card(
      type: obj["type"],
      might: obj["might"],
      movement: obj["movement"],
      cost: obj["cost"],
      owner: obj["owner"],
      specialAbility: obj["specialAbility"],
      numTurnsOnBoard: obj["numTurnsOnBoard"],
    );
  }

}
