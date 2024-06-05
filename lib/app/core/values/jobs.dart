import 'dart:math';
import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';

// the available jobs list
const List<String> jobFilter = [
  'Healer',
  'Ranger',
  'Assassin',
  'Tanker',
  'Fighter',
  'Mage',
  'Necromancer'
];

// the available jobs and chance of each one to drop (the weight)
List<Map<String, dynamic>> jobs = [
  {'name': 'Healer', 'weight': 3},
  //
  {'name': 'Ranger', 'weight': 5},
  //
  {'name': 'Assassin', 'weight': 3},
  //
  {'name': 'Tanker', 'weight': 4},
  //
  {'name': 'Fighter', 'weight': 5},
  //
  {'name': 'Mage', 'weight': 4},
  //
  {'name': 'Necromancer', 'weight': 1},
];

// choose an job based on the wight she have, probability
String weightedRandomSelection(List<Map<String, dynamic>> items) {
  // calculating the chance based on the wight
  int totalWeight = items.fold(0, (sum, item) => sum + (item["weight"] as int));

  //getting a random element after applying the wights
  int random = Random().nextInt(totalWeight);

  int cumulativeWeight =
      0; // will be used for the item wight to check before drooping
  for (var item in items) {
    cumulativeWeight += (item['weight'] as int);
    // if the item wight id bigger than the random number that was choosing from the total wight drop it
    if (random < cumulativeWeight) {
      return item['name'];
    }
  }

  // Fallback (shouldn't reach here)
  return items.last['name'];
}

// responsible for updating the player job in his profile data
void updateClass(String job, BuildContext context) {
  // get user data as var user
  final Profile user = ProfileProvider().readProfile();
  user.job = job;

  // added the job rewords to the user states
  classReword(job, context);
  // save the changes
  ProfileProvider().saveProfile(user, "", context);
}

// the job rewords function, apply rewords based on the job title
Map<String, dynamic> classReword(String job, BuildContext context) {
  Map<String, dynamic> result = {"message": " something wrong happened (0o0!)"};
  // get user States
  UserState state = StatesProvider().readState();

  //? in case the job is Healer
  if (job == jobFilter[0]) {
    // update the states
    state.mana += 25;
    state.vitality += 25;

    // save the changes
    StatesProvider().writeState(state);

    // check if the user have the class before adding it to his jobs list
    checkAndAdd(jobFilter[0], context);
    // return for the snack bar message
    return {"message": "mana 25 vitality 25"};

    //? the same go for the rest jobs titles
  } else if (job == jobFilter[1]) {
    state.agility += 35;
    state.sense += 10;

    checkAndAdd(jobFilter[1], context);
    StatesProvider().writeState(state);

    return {"message": "agility 35 sense 10"};
    //?
  } else if (job == jobFilter[2]) {
    state.sense += 20;
    state.agility += 30;

    checkAndAdd(jobFilter[2], context);
    StatesProvider().writeState(state);

    return {"message": "sense 20 agility 30"};
    //?
  } else if (job == jobFilter[3]) {
    state.vitality += 35;
    state.agility += 10;

    checkAndAdd(jobFilter[3], context);
    StatesProvider().writeState(state);

    return {"message": "vitality 35 agility 10"};
    //?
  } else if (job == jobFilter[4]) {
    state.strength += 25;
    state.vitality += 25;

    checkAndAdd(jobFilter[4], context);
    StatesProvider().writeState(state);

    return {"message": "strength 25 vitality 25"};
    //?
  } else if (job == jobFilter[5]) {
    state.intelligence += 30;
    state.mana += 20;

    checkAndAdd(jobFilter[5], context);
    StatesProvider().writeState(state);

    return {"message": "mana 20 intelligence 30"};
    //?
  } else if (job == jobFilter[6]) {
    state.mana += 30;
    state.intelligence += 30;
    state.agility += 10;
    state.vitality += 10;

    checkAndAdd(jobFilter[6], context);
    StatesProvider().writeState(state);

    return {"message": "mana 30 intelligence 25 agility 10 vitality 10"};
    //?
  } else {
    // in case something happened return the error message, not supposed to happen but just in case
    return result;
  }
}

// check if the use have the job before if yes update it value on the oldJob list if false added it to the list
void checkAndAdd(String title, BuildContext context) {
  // read profile
  final Profile user = ProfileProvider().readProfile();
  // update anyway if new it took the value 0 else the value increase
  updateJopRank(title);

  // if new added it to the list  and save
  if (!user.oldJobs!.contains(title)) {
    user.oldJobs!.add(title);
    ProfileProvider().saveProfile(user, "", context);
  }
}

// update job value, if already existed increase it value by 1 and save
void updateJopRank(String job) {
  // read profile
  final Profile user = ProfileProvider().readProfile();
  // check for each element it's key and rewrite the value
  user.counter.forEach((e) {
    if (e.containsKey(job)) {
      e[job] += 1;
    }
  });
}


// switch the numbers to romanian numbers for the jobs values
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


// get a color depending on the job rank (value) and return it to be used on the information card
Color colorGater(int counterNumber) {
  return counterNumber >= 20
      ? Colors.purple
      : counterNumber >= 15
          ? Colors.red
          : counterNumber >= 10
              ? Colors.indigo
              : counterNumber >= 5
                  ? Colors.teal
                  : counterNumber < 5
                      ? Colors.blue
                      : Colors.blue;
}


// the list is used to create the dynamic jobs folders on the player section at the report screen
List<Map<String, dynamic>> jobList = [
  // every element have it's name icon color, and rewords
  {
    'name': 'Healer',
    'Icon': IconPack.health,
    "color": Colors.blue,
    'text': '+mana 25 +vitality 25'
  },
  //
  {
    'name': 'Ranger',
    'Icon': IconPack.crossbow,
    "color": Colors.teal,
    'text': '+agility 35 +sense 10'
  },
  //
  {
    'name': 'Assassin',
    'Icon': IconPack.bone_knife,
    "color": const Color.fromARGB(255, 65, 33, 243),
    'text': '+sense 20 +agility 30'
  },
  //
  {
    'name': 'Tanker',
    'Icon': IconPack.shield,
    "color": Colors.orange,
    'text': '+vitality 35 +agility 10'
  },
  //
  {
    'name': 'Fighter',
    'Icon': IconPack.fist_raised,
    "color": Colors.red,
    'text': '+strength 25 +vitality 25'
  },
  //
  {
    'name': 'Mage',
    'Icon': IconPack.crystal_wand,
    "color": Colors.green,
    'text': '+mana 20 +intelligence 30'
  },
  //
  {
    'name': 'Necromancer',
    'Icon': IconPack.skull,
    "color": Colors.purple,
    'text': '+mana 30 +intelligence 25 +agility 10 +vitality 10'
  }
];
