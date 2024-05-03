import 'package:equatable/equatable.dart';

class Daily extends Equatable {
  String title;
  int exp;
  bool isGoing;
  bool standard;
  String timeStamp;
  int coins;
  bool isFree;

  Daily({
    required this.title,
    required this.exp,
    this.isGoing = true,
    this.standard = false,
    required this.timeStamp,
    required this.coins,
    this.isFree = false
  });

  Daily copyWith({
    String? title,
    int? exp,
    bool? isGoing,
    bool? standard,
    String? timeStamp,
    bool? isFree,
    int? coins,
  }) =>
      Daily(
        title: title ?? this.title,
        exp: exp ?? this.exp,
        isGoing: isGoing ?? false,
        standard: standard ?? false,
        timeStamp: timeStamp ?? this.timeStamp,
        isFree: isFree ?? false,
        coins: coins ?? this.coins
      );

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        title: json['title'],
        exp: json['exp'],
        isGoing: json['isGoing'],
        standard:json["standard"],
        timeStamp: json["timeStamp"],
        isFree: json["isFree"] ?? false,
        coins: json["coins"] ?? 10
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'exp': exp,
        'isGoing': isGoing,
        'standard':standard,
        'timeStamp':timeStamp,
        'isFree':isFree,
        "coins": coins
      };

  @override
  List<Object?> get props => [title, exp, isGoing,standard,timeStamp, coins];
}
