class deposit {
  String dateTime; // for keeping a track on the actions
  int amount;
  String record; // a brief description about the action
  bool add; // is it withdraw od deposit 

   deposit({
    required this.dateTime,
    required this.amount,
    this.record = "",
    required this.add,
  });

// transforming the object to json string to save it
  deposit copyWith({
    String? dateTime,
    int? amount,
    String? record,
    bool? add,
  }) =>
      deposit(
        dateTime: dateTime ?? this.dateTime,
        amount: amount ?? this.amount,
        record: record ?? this.record,
        add: add ?? this.add,
      );
       // recovering the object from the json string form
  factory deposit.fromJson(Map<String, dynamic> json) => deposit(
        dateTime: json['dateTime'],
        amount: json['amount'],
        record: json['record'] ?? "No Record For That Entry",// in case no record was added
        add: json['add'],
      );
// switching to a json
  Map<String, dynamic> toJson() => {
        'dateTime': dateTime,
        'amount': amount,
        'record': record,
        'add': add,
      };

  @override
  // ignore: override_on_non_overriding_member
  List<Object?> get props => [dateTime, amount, add];
}
