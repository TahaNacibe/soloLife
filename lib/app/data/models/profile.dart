class Profile {
  String userName; 
  int level;
  int exp; // current exp 
  String password; // password
  String rank;
  String job; // class
  int voltage; // voltage level
  int coins; // credit
  String framePath;
  String coverPath;
  String pfpPath;
  String forgetPassword; // the security question and response
  int strike; // current strike
  bool haveMessage;
  String date; 
  List<dynamic> todayShop; // the shop items for today
  List<dynamic>? oldJobs; // old classes and their values
  List<dynamic>? keys; // tools and preferences
  List<dynamic> achievements; 
  List<dynamic> counter; 
  List<dynamic> inventory;

  Profile(
      {required this.userName,
      required this.level,
      required this.exp,
      this.rank = "E",
      this.password = "",
      this.forgetPassword = "",
      this.oldJobs,
      this.voltage = 0,
      this.job = "Empty",
      this.strike = 0,
      this.haveMessage = true,
      this.coins = 0,
      this.keys,
      this.achievements = const [],
      this.framePath = "",
      this.coverPath = "",
      this.pfpPath = "",
      this.date = "",
      this.todayShop = const [],
      this.inventory = const [],
      this.counter = const [
        {'Healer': 0},
        {'Ranger': 0},
        {'Assassin': 0},
        {'Tanker': 0},
        {'Fighter': 0},
        {'Mage': 0},
        {'Necromancer': 0}
      ]});

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
    String? date,
    String? pfpPath,
    String? coverPath,
    List<dynamic>? counter,
    List<dynamic>? todayShop,
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
        strike: strike ?? this.strike,
        achievements: achievements ?? this.achievements,
        oldJobs: oldJobs ?? this.oldJobs,
        voltage: voltage ?? this.voltage,
        coins: coins ?? this.coins,
        haveMessage: haveMessage ?? this.haveMessage,
        counter: counter ?? this.counter,
        framePath: framePath ?? this.framePath,
        pfpPath: pfpPath ?? this.pfpPath,
        coverPath: coverPath ?? this.coverPath,
        inventory: inventory ?? this.inventory,
        date: date ?? this.date,
        todayShop: todayShop ?? this.todayShop
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
        strike: json["strike"] ?? 0,
        coverPath: json["coverPath"] ?? "",
        pfpPath: json["pfpPath"] ?? "",
        inventory: json['inventory'] ?? [],
        date: json['date'],
        todayShop: json['todayShop'],
        haveMessage: json['haveMessage'] ?? true,
        counter: json['counter'] ??
            [
              {'Healer': 0},
              {'Ranger': 0},
              {'Assassin': 0},
              {'Tanker': 0},
              {'Fighter': 0},
              {'Mage': 0},
              {'Necromancer': 0}
            ],
      );

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'level': level,
        'exp': exp,
        'password': password,
        'forgetPassword': forgetPassword,
        'rank': rank,
        'job': job,
        'keys': keys,
        'achievements': achievements,
        'voltage': voltage,
        'oldJobs': oldJobs,
        'haveMessage': haveMessage,
        'counter': counter,
        'framePath': framePath,
        'coverPath': coverPath,
        'pfpPath': pfpPath,
        'strike': strike,
        'coins': coins,
        'date':date,
        'todayShop': todayShop,
        'inventory': inventory,
      };

  List<Object?> get props => [userName, level, exp, rank, coins];
}
