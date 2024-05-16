

import 'dart:math';

import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/shopItem.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';


  List<String> itemsPlane = [
    "AgilityRune","IntelligenceRune","ManaRune",
    "StrengthRune","VitalityRun","SenseRune"]; 

Map<String, dynamic> archive = {
  //? items type Frames
    "TaiShiFrame":ShopItem(title:"art Frame",image:"assets/images/frames/shi.png", price: 500,itemType: "frame", id: "TaiShiFrame",rarity:3),
  "Kitsunee" :ShopItem(title:"Kitsunee Frame",image:"assets/images/frames/limited.png", price: 0,itemType: "frame",id:"Kitsunee",rarity: 3),
   "FoxFrame":ShopItem(title:"Fox Frame",image:"assets/images/frames/fox.png", price: 500,itemType: "frame",id:"FoxFrame",rarity:3),
  "GoldFrame1":ShopItem(title:"Gold1 Frame",image:"assets/images/frames/gold1.png", price: 0,itemType: "frame",id:"GoldFrame1",rarity:3),
  "GoldFrame2":ShopItem(title:"Gold2 Frame",image:"assets/images/frames/gold2.png", price: 500,itemType: "frame",id:"GoldFrame2",rarity:3),
  "DemonFrame":  ShopItem(title:"Demon Frame",image:"assets/images/frames/demon.png", price: 500,itemType: "frame",id:"DemonFrame",rarity:3),
  "MoonFrame":ShopItem(title:"Moon Frame",image:"assets/images/frames/moon.png", price: 500,itemType: "frame",id:"MoonFrame",rarity:4),
  "CloudFrame":ShopItem(title:"Cloud Frame",image:"assets/images/frames/cloud.png", price: 0,itemType: "frame", id: "CloudFrame",rarity:4),
  "NovFrame":  ShopItem(title:"Novilat Frame",image:"assets/images/frames/novilat.png", price: 500,itemType: "frame",id:"NovFrame",rarity:4),
  "McFrame":  ShopItem(title:"Mc Frame",image:"assets/images/frames/mc.png", price: 500,itemType: "frame",id:"McFrame",rarity:4),
  "TravlerFrame":  ShopItem(title:"Travler Frame",image:"assets/images/frames/travler.png", price: 500,itemType: "frame",id:"TravlerFrame",rarity:4),
    "yayFrame":  ShopItem(title:"Yay Frame",image:"assets/images/frames/yay.png", price: 500,itemType: "frame",id:"yayFrame",rarity:4),
  "xiaoFrame":  ShopItem(title:"Xiao Frame",image:"assets/images/frames/xiao.png", price: 500,itemType: "frame",id:"xiaoFrame",rarity:4),
  "AnimatedFrame":  ShopItem(title:"animated Frame",image:"assets/images/frames/animated.png", price: 500,itemType: "frame",id:"AnimatedFrame",rarity:5),
  "ChildFrame":  ShopItem(title:"child Frame",image:"assets/images/frames/child.png", price: 500,itemType: "frame",id:"ChildFrame",rarity:5),
  "GrassFrame":  ShopItem(title:"grass Frame",image:"assets/images/frames/grass.png", price: 500,itemType: "frame",id:"GrassFrame",rarity:5),
  "HomeFrame":  ShopItem(title:"home Frame",image:"assets/images/frames/homi.png", price: 500,itemType: "frame",id:"HomeFrame",rarity:5),
  "HpYpFrame":  ShopItem(title:"Hoyo Frame",image:"assets/images/frames/hpyp.png", price: 500,itemType: "frame",id:"HpYpFrame",rarity:5),
  "IDontFrame":  ShopItem(title:"Something Frame",image:"assets/images/frames/idontknow.png", price: 500,itemType: "frame",id:"IDontFrame",rarity:5),
  "newYearFrame":  ShopItem(title:"NewYear Frame",image:"assets/images/frames/newyear.png", price: 500,itemType: "frame",id:"newYearFrame",rarity:5),
  "RamadanFrame":  ShopItem(title:"Ramadan Frame",image:"assets/images/frames/ramadan.png", price: 500,itemType: "frame",id:"RamadanFrame",rarity:5),
  "SilverFrame":  ShopItem(title:"Silver Frame",image:"assets/images/frames/silver.png", price: 500,itemType: "frame",id:"SilverFrame",rarity:5),
  "WeedFrame":  ShopItem(title:"Weed Frame",image:"assets/images/frames/weed.png", price: 500,itemType: "frame",id:"WeedFrame",rarity:5),
  //? Box's Items List
  "Myst'sBox" :ShopItem(title:"Myst'sBox",image:"assets/images/items/box/newBox.png", price: 15000,itemType: "Box",id:"Myst'sBox",rarity:5,description: "Have a high chance dropping valuable item"),
  "Myst'sBoxCurse": ShopItem(title:"Myst'sBox Curse",image:"assets/images/items/box/cursedBox.png", price: 10000,itemType: "Box",id:"Myst'sBoxCurse",rarity:4,description: "have a small chance of dropping valuable item"),
  "Myst'sBoxOld":ShopItem(title:"Myst'sBox Old",image:"assets/images/items/box/oldBox.png", price: 5000,itemType: "Box",id:"Myst'sBoxOld",rarity:3,description: "have a normal chance of dropping valuable item"),
  "CoinsBag":ShopItem(title: "coins bag", image: "assets/images/items/box/runsBag.png", price: 0, itemType: "coins", id: "CoinsBag",rarity:3,description: "Get a random runes between 20 ~~ 1000"),
  //? Runes Item List
  "StrengthRune":ShopItem(title:"Strength Rune",image:"assets/images/items/full/strength_full.png", price: 1500,itemType: "Rune", id: "StrengthRune",rarity:6,description: "get +50 point to strength"),
  "SenseRune":ShopItem(title:"Sense Rune",image:"assets/images/items/full/sense_full.png", price: 1500,itemType: "Rune", id: "SenseRune",rarity:6,description: "get +50 point to sense"),
  "AgilityRune":ShopItem(title:"Agility Rune",image:"assets/images/items/full/agility_full.png", price: 1500,itemType: "Rune", id: "AgilityRune",rarity:6,description: "get +50 point to agility"),
  "IntelligenceRune":ShopItem(title:"Intelligence Rune",image:"assets/images/items/full/intelligence_full.png", price: 1500,itemType: "Rune", id: "IntelligenceRune",rarity:6,description: "get +50 point to intelligence"),
  "ManaRune":ShopItem(title:"Mana Rune",image:"assets/images/items/full/mana_full.png", price: 1500,itemType: "Rune", id: "ManaRune",rarity:6,description: "get +50 point to Mana"),
  "VitalityRun":ShopItem(title:"Vitality Rune",image:"assets/images/items/full/vitality_full.png", price: 1500,itemType: "Rune", id: "VitalityRun",rarity:6,description: "get +50 point to vitality"),
  //? Runes Items medium List
  "StrengthRuneMedium":ShopItem(title:"Strength Fragment",image:"assets/images/items/medium/strength_medium.png", price: 1500,itemType: "Rune", id: "StrengthRuneMedium",rarity:5,description: "get +25 point to strength"),
  "SenseRuneMedium":ShopItem(title:"Sense Fragment",image:"assets/images/items/medium/sense_medium.png", price: 1500,itemType: "Rune", id: "SenseRuneMedium",rarity:5,description: "get +25 point to sense"),
  "AgilityRuneMedium":ShopItem(title:"Agility Fragment",image:"assets/images/items/medium/agility_medium.png", price: 1500,itemType: "Rune", id: "AgilityRuneMedium",rarity:5,description: "get +50 point to agility"),
  "IntelligenceRuneMedium":ShopItem(title:"Intelligence Fragment",image:"assets/images/items/medium/intelligence_medium.png", price: 1500,itemType: "Rune", id: "IntelligenceRuneMedium",rarity:5,description: "get +25 point to intelligence"),
  "ManaRuneMedium":ShopItem(title:"Mana Fragment",image:"assets/images/items/medium/mana_medium.png", price: 1500,itemType: "Rune", id: "ManaRuneMedium",rarity:5,description: "get +25 point to mana"),
  "VitalityRunMedium":ShopItem(title:"Vitality Fragment",image:"assets/images/items/medium/vitality_medium.png", price: 1500,itemType: "Rune", id: "VitalityRunMedium",rarity:5,description: "get +25 point to vitality"),
  //? Runes Items small List
  "StrengthRuneSmall":ShopItem(title:"Strength Shard ",image:"assets/images/items/small/strength_small.png", price: 1500,itemType: "Rune", id: "StrengthRuneSmall",rarity:4,description: "get +10 point to strength"),
  "SenseRuneSmall":ShopItem(title:"Sense Shard ",image:"assets/images/items/small/sense_small.png", price: 1500,itemType: "Rune", id: "SenseRuneSmall",rarity:4,description: "get +10 point to sense"),
  "AgilityRuneSmall":ShopItem(title:"Agility Shard ",image:"assets/images/items/small/agility_small.png", price: 1500,itemType: "Rune", id: "AgilityRuneSmall",rarity:4,description: "get +10 point to agility"),
  "IntelligenceRuneSmall":ShopItem(title:"Intelligence Shard ",image:"assets/images/items/small/intelligence_small.png", price: 1500,itemType: "Rune", id: "IntelligenceRuneSmall",rarity:4,description: "get +10 point to intelligence"),
  "ManaRuneSmall":ShopItem(title:"Mana Shard ",image:"assets/images/items/small/mana_small.png", price: 1500,itemType: "Rune", id: "ManaRuneSmall",rarity:4,description: "get +10 point to mana"),
  "VitalityRunSmall":ShopItem(title:"Vitality Shard ",image:"assets/images/items/small/vitality_small.png", price: 1500,itemType: "Rune", id: "VitalityRunSmall",rarity:4,description: "get +10 point to vitality"),
  };

Map<String, double> itemProbabilities = {
  'MoonFrame': 0.01,
  'CloudFrame': 0.02,
  'TaiShiFrame': 0.01,
  'StrengthRune': 0.000001,
  'VitalityRun': 0.000001,
  'Kitsunee': 0.09,
  'SenseRune': 0.000001,
  'FoxFrame': 0.05,
  'GoldFrame1': 0.05,
  'GoldFrame2': 0.05,
  'DemonFrame': 0.01,
  "CoinsBag": 0.8, // Adjusted probability
  "AnimatedFrame":0.01,
  "ChildFrame":0.2,
  "GrassFrame":0.2,
  "HomeFrame":0.2,
  "HpYpFrame":0.3,
  "IDontFrame":0.1,
  "McFrame":0.1,
  "newYearFrame":0.3,
  "NovFrame":0.4,
  "RamadanFrame":0.2,
  "SilverFrame":0.2,
  "TravlerFrame":0.2,
  "WeedFrame":0.3,
  "xiaoFrame":0.3,
  "yayFrame":0.2,
};

Map<String, double> oldItemProbabilities = {
  'MoonFrame': 0.009,
  'CloudFrame': 0.009,
  'TaiShiFrame': 0.009,
  'StrengthRune': 0.0000009,
  'VitalityRun': 0.0000009,
  'Kitsunee': 0.09,
  'SenseRune': 0.0000009,
  'FoxFrame': 0.007,
  'GoldFrame1': 0.007,
  'GoldFrame2': 0.007,
  'DemonFrame': 0.009,
  "CoinsBag": 0.8, // Adjusted probability
    "AnimatedFrame":0.01,
  "ChildFrame":0.09,
  "GrassFrame":0.09,
  "HomeFrame":0.09,
  "HpYpFrame":0.1,
  "IDontFrame":0.07,
  "McFrame":0.07,
  "newYearFrame":0.1,
  "NovFrame":0.2,
  "RamadanFrame":0.1,
  "SilverFrame":0.1,
  "TravlerFrame":0.1,
  "WeedFrame":0.09,
  "xiaoFrame":0.1,
  "yayFrame":0.07,
};

Map<String, double> curseItemProbabilities = {
  'MoonFrame': 0.003,
  'CloudFrame': 0.003,
  'TaiShiFrame': 0.004,
  'StrengthRune': 0.0000001,
  'VitalityRun': 0.0000001,
  'Kitsunee': 0.009,
  'SenseRune': 0.0000001,
  'FoxFrame': 0.005,
  'GoldFrame1': 0.005,
  'GoldFrame2': 0.005,
  'DemonFrame': 0.003,
  "CoinsBag": 0.009, // Adjusted probability
    "AnimatedFrame":0.0001,
  "ChildFrame":0.002,
  "GrassFrame":0.002,
  "HomeFrame":0.002,
  "HpYpFrame":0.003,
  "IDontFrame":0.001,
  "McFrame":0.001,
  "newYearFrame":0.003,
  "NovFrame":0.004,
  "RamadanFrame":0.002,
  "SilverFrame":0.002,
  "TravlerFrame":0.002,
  "WeedFrame":0.003,
  "xiaoFrame":0.003,
  "yayFrame":0.002,
};


List<dynamic> getRandomItems(int count) {
  List<dynamic> randomItems = [];

  List<dynamic> itemsByRarity = archive.values.toList();
  //itemsByRarity.removeWhere((element) => element.type == "Box" || element.type == "frame");
  itemsByRarity.shuffle(); // Shuffle to ensure randomness based on rarity

  for (int i = 0; i < itemsByRarity.length; i++) {
    if (itemsByRarity[i].itemType != "frame" && itemsByRarity[i].itemType != "Box") {
      int dropProbability = 100 ~/ itemsByRarity[i].rarity; // Adjust drop probability based on rarity
      if (itemsByRarity[i].rarity == 6) {
        dropProbability = dropProbability ~/ 2; // Double drop probability for items with rarity 6
      }
      if (Random().nextInt(100) < dropProbability) {
        randomItems.add(itemsByRarity[i]);
        if (randomItems.length == count) break;
      }
    }
  }
  return randomItems;
}



List<dynamic> getRandomFrames(int count) {
  List<dynamic> randomItems = [];

  List<dynamic> itemsByRarity = archive.values.toList();
  itemsByRarity.shuffle(); // Shuffle to ensure randomness based on rarity

  for (int i = 0; i < itemsByRarity.length; i++) {
    if (itemsByRarity[i].itemType == "frame") {
      int dropProbability = 100 ~/ itemsByRarity[i].rarity; // Adjust drop probability based on rarity
      if (itemsByRarity[i].rarity == 6) {
        dropProbability = dropProbability ~/ 2; // Double drop probability for items with rarity 6
      }
      if (Random().nextInt(100) < dropProbability) {
        randomItems.add(itemsByRarity[i]);
        if (randomItems.length == count) break;
      }
    }
  }
  return randomItems;
}


int getRandomNumber() {
  // Generate a random number between 0 and 1
  double randomValue = Random().nextDouble();

  // Scale the random value to fit the range [20, 1000]
  double scaledValue = randomValue * (10000 - 20) + 20;

  // Apply square root function to adjust the distribution
  double scaledBackValue = sqrt(scaledValue);

  // Convert the scaled value back to the integer range
  int result = scaledBackValue.toInt();

  return result;
}