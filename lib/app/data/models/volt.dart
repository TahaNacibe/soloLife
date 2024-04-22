class Volt {
  String title;
  bool isPositive;


   Volt({
    required this.title,
    required this.isPositive,
  });

  Volt copyWith({
    String? title,
    int? amount,
    bool? isPositive,
  }) =>
      Volt(
        title: title ?? this.title,
        isPositive: isPositive ?? this.isPositive,
      );

  factory Volt.fromJson(Map<String, dynamic> json) => Volt(
        title: json['title'],
        isPositive: json['isPositive'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'isPositive': isPositive,
      };

  List<Object?> get props => [title, isPositive];
}
