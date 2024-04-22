import 'dart:math' as math;
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';

bool monster = ProfileProvider().readProfile().keys!.contains("monster");

//? get the exp cap for the current level
int getExpToNextLevel(int currentLevel, {double growthFactor = 3, int baseExp = 100}) {
  // the negative level case
  if (currentLevel <= 0) {
    throw ArgumentError('Current level cannot be zero or negative.');
  }
  // get the cap of xp based on the level
  int result = 1;
  result = (baseExp * math.pow(1.03+ growthFactor / currentLevel, currentLevel)).toInt();
  currentLevel = currentLevel+1;
  return monster? result*2 : result;
}

//? random exp set for the quests
int getExpForTheTasks(int currentLevel,isFree){
  // init the package
  final random = math.Random();
  int result = 0;
  // get the xp
    result = random.nextInt(50 - 20) + 20; // + 1 for inclusive max
    double equalizer = currentLevel == 1? 1 : currentLevel/2;
    result = (result*equalizer).toInt();
  return isFree? 0 : result;
}

//? manage the main quests
Map mainQuests(String title,int level,bool monster){
  List<String> parts = title.split('[',);
  String number = parts[1].replaceAll(']', '');
  int result = 0;
  int value = level~/10 == 0? 1 : level~/10;
  if(!title.contains('Km')){
    result = int.parse(number);
    result = monster? result*value : result;
    return {"title":parts[0],"number":result};
  }else{
    result = int.parse(number.replaceAll("Km", ''));
    result = monster? result+value : result;
    return {"title":parts[0],"number":"${result}Km"};
  }
}
//? Manual Quests
Map sideQuests(String title,){
  List<String> parts = title.split('[',);
  if(parts.length == 1){
    
    return {"title":parts[0],"number":""};
  }else{
    String result = parts[1].replaceAll(']', '');
    return {"title":parts[0],"number":"${result}"};
  }
  
}
//? added exp to player
void addExp(int exp){
  Profile user = ProfileProvider().readProfile();
  user.exp = user.exp + exp;
  ProfileProvider().saveProfile(user, "exp");
}

//? manage the ranks
Map<String,dynamic> rankManager(){
  List<UserState> requirement = [
    // D rank -- 20
    UserState(agility: 1,intelligence: 1,sense: 1,strength: 30,vitality: 15,mana: 1),
    // C rank -- 50
    UserState(agility: 1,intelligence: 20,sense: 1,strength: 1,vitality: 1,mana: 30),
    // B rank -- 80
    UserState(agility: 60,intelligence: 1,sense: 30,strength: 1,vitality: 1,mana: 1),
    // A rank -- 150
    UserState(agility: 1,intelligence: 1,sense: 1,strength: 80,vitality: 80,mana: 1),
    // S rank -- 250
    UserState(agility: 100,intelligence: 100,sense: 100,strength: 200,vitality: 200,mana: 200),
    // SS rank -- 500
    UserState(agility: 200,intelligence: 220,sense: 200,strength: 400,vitality: 400,mana: 400),
    // SSS rank -- 750
    UserState(agility: 400,intelligence: 400,sense: 400,strength: 800,vitality: 800,mana: 800),
    // Z rank -- 1000
    UserState(agility: 800,intelligence: 900,sense: 900,strength: 1600,vitality: 1600,mana: 1600),
  ];
  UserState userState = StatesProvider().readState();
  Profile profile = ProfileProvider().readProfile();
  Map<String,dynamic> rank = {"change":false,"rank":"Didn't meat the requirement"};
  switch (profile.rank) {
    case "E":
    if(checkState(userState, requirement[0])){
      rank = {"change":true,"rank":"D"};
      rankUp("D");
    }else{
      return {"change":false,"rank":"Require strength: 30 vitality: 15"};
    }
    case "D":
      if(checkState(userState, requirement[1])){
      rank = {"change":true,"rank":"C"};
            rankUp("C");

    }else{
      return {"change":false,"rank":"Require intelligence: 20 mana: 30"};
    }
    case "C":
      if(checkState(userState, requirement[2])){
      rank = {"change":true,"rank":"B"};
            rankUp("B");

    }else{
      return {"change":false,"rank":"Require agility: 60 sense: 30"};
    }
    case "B":
      if(checkState(userState, requirement[3])){
      rank = {"change":true,"rank":"A"};
            rankUp("A");

    }else{
      return {"change":false,"rank":"Require strength: 80 vitality: 80"};
    }
    case "A":
        if(checkState(userState, requirement[4])){
      rank = {"change":true,"rank":"S"};
            rankUp("S");

    }else{
      return {"change":false,"rank":"Require agility: 100,intelligence: 100,sense: 100,strength: 200,vitality: 200,mana: 200"};
    }
     case "S":
          if(checkState(userState, requirement[4])){
      rank = {"change":true,"rank":"SS"};
            rankUp("SS");

    }else{
      return {"change":false,"rank":"Require agility: 200,intelligence: 220,sense: 200,strength: 400,vitality: 400,mana: 400"};
    }
    case "SS":
           if(checkState(userState, requirement[4])){
      rank = {"change":true,"rank":"SSS"};
            rankUp("SSS");

    }else{
      return {"change":false,"rank":"Require agility: 400,intelligence: 400,sense: 400,strength: 800,vitality: 800,mana: 800"};
    }
    case "SSS":
           if(checkState(userState, requirement[4])){
      rank = {"change":true,"rank":"Z"};
            rankUp("Z");

    }else{
      return {"change":false,"rank":"Require agility: 800,intelligence: 900,sense: 900,strength: 1600,vitality: 1600,mana: 1600"};
    }
  }
  return rank;
}

bool checkState(UserState state,UserState otherState){
  return (state.agility >= otherState.agility 
  && state.intelligence >= otherState.intelligence 
  && state.mana >= otherState.mana 
  && state.sense >= otherState.sense 
  && state.strength >= otherState.strength 
  && state.vitality >= otherState.vitality);
}

void rankUp(String rank){
  Profile user = ProfileProvider().readProfile();
  user.rank = rank;
  ProfileProvider().saveProfile(user, "");
}