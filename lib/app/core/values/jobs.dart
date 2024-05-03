import 'dart:math';
import 'dart:ui';

import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> jobs = [
  {'name': 'Healer', 'weight': 3},
  {'name': 'Ranger', 'weight': 5},
  {'name': 'Assassin', 'weight': 3},
  {'name': 'Tanker', 'weight': 4},
  {'name': 'Fighter', 'weight': 5},
  {'name': 'Mage', 'weight': 4},
  {'name': 'Necromancer', 'weight': 1},
  // Add more items as needed
];

String weightedRandomSelection(List<Map<String, dynamic>> items) {
  int totalWeight = items.fold(0, (sum, item) => sum + (item["weight"] as int));
  int random = Random().nextInt(totalWeight);

  int cumulativeWeight = 0;
  for (var item in items) {
    cumulativeWeight += (item['weight'] as int);
    if (random < cumulativeWeight) {
      return item['name'];
    }
  }

  // Fallback (shouldn't reach here)
  return items.last['name'];
}

void updateClass(String job){
  // get user data as var user
    final Profile user = ProfileProvider().readProfile();
    user.job = job;
   ProfileProvider().saveProfile(user, "");

}


const List<String> jobFilter = ['Healer','Ranger','Assassin','Tanker','Fighter','Mage','Necromancer'];
Map<String,dynamic> classReword(String job){
  Map<String,dynamic> result = {"message":" error (0o0!)"};
  // get user States 
  UserState state = StatesProvider().readState();
  if(job == jobFilter[0]){
    state.mana += 25;
    state.vitality +=25;
    StatesProvider().writeState(state);
    checkAndAdd(jobFilter[0]);
    return {"message":"mana 25 vitality 25"};
  }else if(job == jobFilter[1]){
    state.agility +=35;
    state.sense +=10;
    checkAndAdd(jobFilter[1]);
    StatesProvider().writeState(state);
    return {"message":"agility 35 sense 10"};
  }else if(job == jobFilter[2]){
    state.sense +=20;
    state.agility +=30;
    checkAndAdd(jobFilter[2]);
    StatesProvider().writeState(state);
    return {"message":"sense 20 agility 30"};
  }else if(job == jobFilter[3]){
    state.vitality += 35;
    state.agility += 10;
    checkAndAdd(jobFilter[3]);
    StatesProvider().writeState(state);
    return {"message":"vitality 35 agility 10"};
  }else if(job == jobFilter[4]){
    state.strength +=25;
    state.vitality +=25;
    checkAndAdd(jobFilter[4]);
    StatesProvider().writeState(state);
    return {"message":"strength 25 vitality 25"};
  }else if(job == jobFilter[5]){
    state.intelligence +=30;
    state.mana +=20;
    checkAndAdd(jobFilter[5]);
    StatesProvider().writeState(state);
    return {"message":"mana 20 intelligence 30"};
  }else if(job == jobFilter[6]){
    state.mana +=30;
    state.intelligence +=30;
    state.agility += 10;
    state.vitality +=10;
    checkAndAdd(jobFilter[6]);
    StatesProvider().writeState(state);
    return {"message":"mana 30 intelligence 25 agility 10 vitality 10"};
  }else{
    return result;
  }
}

void checkAndAdd(String title){
  final Profile user = ProfileProvider().readProfile();
  updateJopRank(title);
  if(!user.oldJobs!.contains(title)){
    user.oldJobs!.add(title);
    ProfileProvider().saveProfile(user, "");
  }
}

void updateJopRank(String job){
  final Profile user = ProfileProvider().readProfile();
  user.counter.forEach((e){
    if(e.containsKey(job)){
      e[job] += 1;
    }
  });
}

String convertToRomanNumeral(int number) {
  switch (number) {
    case 0:
      return '0';
    case 1:
      return 'I';
    case 2:
      return 'II';
    case 3:
      return 'III';
    case 4:
      return 'IV';
    case 5:
      return 'V';
    case 6:
      return 'VI';
    case 7:
      return 'VII';
    case 8:
      return 'VIII';
    case 9:
      return 'IX';
    case 10:
      return 'X';
    case 11:
      return 'XI';
    case 12:
      return 'XII';
    case 13:
      return 'XIII';
    case 14:
      return 'XIV';
    case 15:
      return 'XV';
    case 16:
      return 'XVI';
    case 17:
      return 'XVII';
    case 18:
      return 'XVIII';
    case 19:
      return 'XIX';
    case 20:
      return 'XX';
    case 21:
      return 'XXI';
    case 22:
      return 'XXII';
    case 23:
      return 'XXIII';
    case 24:
      return 'XXIV';
    case 25:
      return 'XXV';
    default:
      return 'Z';
  }
}

Color colorGater(int counterNumber){
  return counterNumber >= 20? Colors.purple : counterNumber >=15? Colors.red: counterNumber >= 10? Colors.orange: counterNumber >= 5? Colors.teal :counterNumber < 5? Colors.blue: Colors.blue;
}