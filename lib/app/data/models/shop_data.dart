import 'dart:math' as math;
import 'package:SoloLife/app/core/utils/items_archive.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/shopItem.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';


class ShopData {
  String date;
  String todayList;

  ShopData({
    required this.date,
    required this.todayList,
  });

  ShopData copyWith({
    String? date,
    String? todayList,
  }) =>
      ShopData(
        date: date ?? this.date,
        todayList: todayList ?? this.todayList,
      );

  factory ShopData.fromJson(Map<String, dynamic> json) => ShopData(
        date: json['dateTime'],
        todayList: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        "dateTime": date,
        "amount": todayList,
      };

  @override
  List<Object?> get props => [date, todayList];
}

//? the shop item
ShopData shopData() {
  ShopData data = ShopData(date: "${DateTime.now().day}", todayList: "");
  List<dynamic> items = archive.values.toList();
  List<dynamic> frames =
      items.where((element) => element.itemType == "frame").toList();
  List<dynamic> runes =
      items.where((element) => element.itemType == "Rune").toList();

  for (var i = 0; i < 6; i++) {
    ShopItem test = getRandomItem(frames);
    if (!data.todayList.contains(test.id)) {
      data.todayList = data.todayList + "_${test.id}";
    } else {
      i -= 1;
    }
  }
  for (var i = 0; i < 6; i++) {
    ShopItem test = getRandomItem(runes);
    if (!data.todayList.contains(test.id)) {
      data.todayList = data.todayList + "_${test.id}";
    } else {
      i -= 1;
    }
  }
  return data;
}

// getting the random elements list 
ShopItem getRandomItem(List<dynamic> items) {
  List<double> weights = items.map((item) {
    return item.rarity == 6
        ? 0.1
        : item.rarity == 5
            ? 0.2
            : 1.0;
  }).toList();
   // using the wights 
  double totalWeight = weights.reduce((a, b) => a + b);
  List<double> normalizedWeights =
      weights.map((weight) => weight / totalWeight).toList();

  List<double> cumulativeWeights = [];
  double cumulative = 0.0;
  for (double weight in normalizedWeights) {
    cumulative += weight;
    cumulativeWeights.add(cumulative);
  }

  double randomValue = math.Random().nextDouble();
  for (int i = 0; i < cumulativeWeights.length; i++) {
    if (randomValue <= cumulativeWeights[i]) {
      return items[i];
    }
  }
  // return the values
  return items.last;
}

// reset the shop every day at 00:00
void shopReset(BuildContext context) {
  Profile user = ProfileProvider().readProfile();
  // if the date isn't empty, wish mean there is a shop data before
  if (user.date.isNotEmpty) {
    if (DateTime.now().day != int.parse(user.date)) {
      user.date = "${DateTime.now().day}";
      user.todayShop = shopData().todayList.split("_");
      ProfileProvider().saveProfile(user, "", context);
    }
  } else {
    user.date = "${DateTime.now().day}";
    user.todayShop = shopData().todayList.split("_");
    ProfileProvider().saveProfile(user, "", context);
  }
}
