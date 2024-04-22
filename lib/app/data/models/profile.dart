
 late String date = "${DateTime.now()}";
class Profile {
  String userName;
  int level;
  int exp;
  String password ;
  String rank;
  String job;
  int voltage;
  bool haveMessage;
  List<dynamic>? oldJobs;
  List<dynamic>? keys;
  List<dynamic> counter;

   Profile({
    required this.userName,
    required this.level,
    required this.exp,
    this.rank = "E",
    this.password = "",
    this.oldJobs,
    this.voltage = 0,
    this.job = "Empty",
    this.haveMessage = true,
    this.keys,
    this.counter = const [
          {'Healer':0},{'Ranger':0},{'Assassin':0},
          {'Tanker':0},{'Fighter':0},{'Mage':0},
          {'Necromancer':0}]
  });

  Profile copyWith({
    String? userName,
    int? level,
    int? exp,
    String? password,
    String? rank,
    int? strike,
    String? job,
    List<dynamic>? keys,
    List<dynamic>? oldJobs,
    int? voltage,
    bool? haveMessage,
    List<dynamic>? counter
  }) =>
      Profile(
        userName: userName ?? this.userName,
        level: level ?? this.level,
        exp: exp ?? this.exp,
        password: password ?? this.password,
        job: job ?? this.job,
        rank: rank ?? this.rank,
        keys: keys ?? this.keys,
        oldJobs: oldJobs ?? this.oldJobs,
        voltage: voltage ?? this.voltage,
        haveMessage: haveMessage ?? this.haveMessage,
        counter:counter ?? this.counter
      );

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        userName: json['userName'],
        level: json['level'],
        exp: json['exp'],
        password: json['password'],
        job: json['job'] ?? "Empty",
        rank: json['rank'],
        keys: json['keys'],
        oldJobs: json['oldJobs'] ?? [],
        voltage: json['voltage'] ?? 0,
        haveMessage: json['haveMessage'] ?? true,
        counter: json['counter'] ?? [
          {'Healer':0},{'Ranger':0},{'Assassin':0},
          {'Tanker':0},{'Fighter':0},{'Mage':0},
          {'Necromancer':0}],
      );

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'level': level,
        'exp': exp,
        'password':password,
        'rank':rank,
        'job': job,
        'keys': keys,
        'voltage':voltage,
        'oldJobs':oldJobs,
        'haveMessage':haveMessage,
        'counter':counter
      };

  List<Object?> get props => [userName, level, exp,rank];
}
