
class Profile {
  String userName;
  int level;
  int exp;
  String password ;
  String rank;
  String job;
  int voltage;
  int coins;
  String framePath;
  String forgetPassword;
  bool haveMessage;
  List<dynamic>? oldJobs;
  List<dynamic>? keys;
  List<dynamic> achievements;
  List<dynamic> counter;
  List<dynamic> inventory;

   Profile({
    required this.userName,
    required this.level,
    required this.exp,
    this.rank = "E",
    this.password = "",
    this.forgetPassword = "",
    this.oldJobs,
    this.voltage = 0,
    this.job = "Empty",
    this.haveMessage = true,
    this.coins = 0,
    this.keys,
    this.achievements = const[],
    this.framePath = "",
    this.inventory = const [],
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
    String? forgetPassword,
    String? rank,
    int? strike,
    String? job,
    List<dynamic>? keys,
    List<dynamic>? achievements,
    List<dynamic>? oldJobs,
    int? voltage,
    bool? haveMessage,
    int? coins,
    String? framePath,
    List<dynamic>? counter,
    List<dynamic>? inventory,
  }) =>
      Profile(
        userName: userName ?? this.userName,
        level: level ?? this.level,
        exp: exp ?? this.exp,
        password: password ?? this.password,
        forgetPassword: forgetPassword ?? this.forgetPassword,
        job: job ?? this.job,
        rank: rank ?? this.rank,
        keys: keys ?? this.keys,
        achievements: achievements ?? this.achievements,
        oldJobs: oldJobs ?? this.oldJobs,
        voltage: voltage ?? this.voltage,
        coins: coins ?? this.coins,
        haveMessage: haveMessage ?? this.haveMessage,
        counter:counter ?? this.counter,
        framePath: framePath ?? this.framePath,
        inventory: inventory ?? this.inventory,
      );

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        userName: json['userName'],
        level: json['level'],
        exp: json['exp'],
        password: json['password'],
        forgetPassword: json['forgetPassword'] ?? "",
        job: json['job'] ?? "Empty",
        rank: json['rank'],
        keys: json['keys'],
        achievements: json['achievements'] ?? [],
        oldJobs: json['oldJobs'] ?? [],
        voltage: json['voltage'] ?? 0,
        coins: json["coins"] ?? 0,
        framePath: json["framePath"] ?? "",
        inventory: json['inventory'] ?? [],
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
        'forgetPassword':forgetPassword,
        'rank':rank,
        'job': job,
        'keys': keys,
        'achievements': achievements,
        'voltage':voltage,
        'oldJobs':oldJobs,
        'haveMessage':haveMessage,
        'counter':counter,
        'framePath': framePath,
        'coins': coins,
        'inventory': inventory,
      };

  List<Object?> get props => [userName, level, exp,rank,coins];
}
