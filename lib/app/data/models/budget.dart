class Budget {
  String dateTime;
  int amount;
  String record;
  bool add;

   Budget({
    required this.dateTime,
    required this.amount,
    this.record = "",
    required this.add,
  });

  Budget copyWith({
    String? dateTime,
    int? amount,
    String? record,
    bool? add,
  }) =>
      Budget(
        dateTime: dateTime ?? this.dateTime,
        amount: amount ?? this.amount,
        record: record ?? this.record,
        add: add ?? this.add,
      );

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        dateTime: json['dateTime'],
        amount: json['amount'],
        record: json['record'] ?? "No Record For That Entry",
        add: json['add'],
      );

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime,
        'amount': amount,
        'record': record,
        'add': add,
      };

  @override
  List<Object?> get props => [dateTime, amount, add];
}
