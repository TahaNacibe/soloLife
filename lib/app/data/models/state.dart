
class UserState {
  int strength;
  int agility;
  int sense;
  int vitality;
  int intelligence;
  int points;
  int mana;
   UserState({
    this.agility = 1,
    this.intelligence =1,
    this.sense = 1,
    this.strength = 10,
    this.vitality = 1,
    this.points = 0,
    this.mana = 10,
  });

  UserState copyWith({
    int? agility,
    int? intelligence,
    int? sense,
    int? strength,
    int? vitality,
    int? points,
    int? mana,
  }) =>
      UserState(
        agility: agility ?? this.agility,
        intelligence: intelligence ?? this.intelligence,
        sense: sense ?? this.sense,
        strength: strength ?? this.strength,
        vitality: vitality ?? this.vitality,
        points: points ?? this.points,
        mana:mana ?? this.mana
      );

  factory UserState.fromJson(Map<String, dynamic> json) => UserState(
        intelligence: json['intelligence'],
        agility: json['agility'],
        sense: json['sense'],
        strength: json['strength'],
        vitality: json['vitality'],
        points: json['points'],
        mana:json['mana'],
      );

  Map<String, dynamic> toJson() => {
        'intelligence': intelligence,
        'agility': agility,
        'sense': sense,
        'strength':strength,
        'vitality': vitality,
        'points':points,
        'mana':mana,
      };

}
