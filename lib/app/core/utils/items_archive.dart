import 'dart:math';
import 'package:SoloLife/app/data/models/shopItem.dart';

// all the app items are here archived from frames to runes and boxes
// changing the value here effect the entire app
// deleting items remove them off the app (the case of not founding item was handled already so just deleting is enough to remove it)
Map<String, dynamic> archive = {
  //? items type Frames
  "Frame1": ShopItem(
      title: "Frame1",
      image: "assets/images/frames/frame1.png",
      price: 1000,
      itemType: "frame",
      id: "Frame1",
      rarity: 3),
  "Frame3": ShopItem(
      title: "Frame3",
      image: "assets/images/frames/frame3.png",
      price: 1000,
      itemType: "frame",
      id: "Frame3",
      rarity: 3),
  "Frame4": ShopItem(
      title: "Frame4",
      image: "assets/images/frames/frame4.png",
      price: 1000,
      itemType: "frame",
      id: "Frame4",
      rarity: 3),
  "Frame5": ShopItem(
      title: "Frame5",
      image: "assets/images/frames/frame5.png",
      price: 2000,
      itemType: "frame",
      id: "Frame5",
      rarity: 4),
  "Frame6": ShopItem(
      title: "Frame6",
      image: "assets/images/frames/frame6.png",
      price: 2000,
      itemType: "frame",
      id: "Frame6",
      rarity: 4),
  "Frame7": ShopItem(
      title: "Frame7",
      image: "assets/images/frames/frame7.png",
      price: 2000,
      itemType: "frame",
      id: "Frame7",
      rarity: 4),
  "Frame8": ShopItem(
      title: "Frame8",
      image: "assets/images/frames/frame8.png",
      price: 2000,
      itemType: "frame",
      id: "Frame8",
      rarity: 4),
  "Frame9": ShopItem(
      title: "Frame9",
      image: "assets/images/frames/frame9.png",
      price: 2000,
      itemType: "frame",
      id: "Frame9",
      rarity: 4),
  "Frame10": ShopItem(
      title: "Frame10",
      image: "assets/images/frames/frame10.png",
      price: 2000,
      itemType: "frame",
      id: "Frame10",
      rarity: 4),
  "Frame11": ShopItem(
      title: "Frame11",
      image: "assets/images/frames/frame11.png",
      price: 2000,
      itemType: "frame",
      id: "Frame11",
      rarity: 4),
  "Frame12": ShopItem(
      title: "Frame12",
      image: "assets/images/frames/frame12.png",
      price: 3500,
      itemType: "frame",
      id: "Frame12",
      rarity: 5),
  "Frame13": ShopItem(
      title: "Frame13",
      image: "assets/images/frames/frame13.png",
      price: 3500,
      itemType: "frame",
      id: "Frame13",
      rarity: 5),
  "Frame14": ShopItem(
      title: "Frame14",
      image: "assets/images/frames/frame14.png",
      price: 3500,
      itemType: "frame",
      id: "Frame14",
      rarity: 5),
  "Frame15": ShopItem(
      title: "Frame15",
      image: "assets/images/frames/frame15.png",
      price: 3500,
      itemType: "frame",
      id: "Frame15",
      rarity: 5),
  "Frame16": ShopItem(
      title: "Frame16",
      image: "assets/images/frames/frame16.png",
      price: 3500,
      itemType: "frame",
      id: "Frame16",
      rarity: 5),
  "Frame17": ShopItem(
      title: "Frame17",
      image: "assets/images/frames/frame17.png",
      price: 3500,
      itemType: "frame",
      id: "Frame17",
      rarity: 5),
  "Frame18": ShopItem(
      title: "Frame18",
      image: "assets/images/frames/frame18.png",
      price: 3500,
      itemType: "frame",
      id: "Frame18",
      rarity: 5),
  "Frame19": ShopItem(
      title: "Frame19",
      image: "assets/images/frames/frame19.png",
      price: 1000,
      itemType: "frame",
      id: "Frame19",
      rarity: 5),
  "Frame20": ShopItem(
      title: "Frame20",
      image: "assets/images/frames/frame20.png",
      price: 3500,
      itemType: "frame",
      id: "Frame20",
      rarity: 5),
  "Frame21": ShopItem(
      title: "Frame21",
      image: "assets/images/frames/frame21.png",
      price: 3500,
      itemType: "frame",
      id: "Frame21",
      rarity: 5),
  "Frame24": ShopItem(
      title: "Frame24",
      image: "assets/images/frames/frame24.png",
      price: 3500,
      itemType: "frame",
      id: "Frame24",
      rarity: 5),
  "Frame25": ShopItem(
      title: "Frame25",
      image: "assets/images/frames/frame25.png",
      price: 1000,
      itemType: "frame",
      id: "Frame25",
      rarity: 5),
  "Frame26": ShopItem(
      title: "Frame26",
      image: "assets/images/frames/frame26.png",
      price: 1000,
      itemType: "frame",
      id: "Frame26",
      rarity: 5),
  "Frame27": ShopItem(
      title: "Frame27",
      image: "assets/images/frames/frame27.png",
      price: 2000,
      itemType: "frame",
      id: "Frame27",
      rarity: 5),
  "Frame29": ShopItem(
      title: "Frame28",
      image: "assets/images/frames/frame28.png",
      price: 2000,
      itemType: "frame",
      id: "Frame28",
      rarity: 5),
  //? Box's Items List
  "Myst'sBox": ShopItem(
      title: "Myst'sBox",
      image: "assets/images/items/box/newBox.png",
      price: 15000,
      itemType: "Box",
      id: "Myst'sBox",
      rarity: 5,
      description: "Have a high chance dropping valuable item"),
  "Myst'sBoxCurse": ShopItem(
      title: "Myst'sBox Curse",
      image: "assets/images/items/box/cursedBox.png",
      price: 10000,
      itemType: "Box",
      id: "Myst'sBoxCurse",
      rarity: 4,
      description: "have a small chance of dropping valuable item"),
  "Myst'sBoxOld": ShopItem(
      title: "Myst'sBox Old",
      image: "assets/images/items/box/oldBox.png",
      price: 5000,
      itemType: "Box",
      id: "Myst'sBoxOld",
      rarity: 3,
      description: "have a normal chance of dropping valuable item"),
  "CoinsBag": ShopItem(
      title: "coins bag",
      image: "assets/images/items/box/runsBag.png",
      price: 0,
      itemType: "coins",
      id: "CoinsBag",
      rarity: 3,
      description: "Get a random runes between 20 ~~ 1000"),
  //? Runes Item List
  "StrengthRune": ShopItem(
      title: "Strength Rune",
      image: "assets/images/items/full/strength_full.png",
      price: 8000,
      itemType: "Rune",
      id: "StrengthRune",
      rarity: 6,
      description: "get +50 point to strength"),
  "SenseRune": ShopItem(
      title: "Sense Rune",
      image: "assets/images/items/full/sense_full.png",
      price: 8000,
      itemType: "Rune",
      id: "SenseRune",
      rarity: 6,
      description: "get +50 point to sense"),
  "AgilityRune": ShopItem(
      title: "Agility Rune",
      image: "assets/images/items/full/agility_full.png",
      price: 8000,
      itemType: "Rune",
      id: "AgilityRune",
      rarity: 6,
      description: "get +50 point to agility"),
  "IntelligenceRune": ShopItem(
      title: "Intelligence Rune",
      image: "assets/images/items/full/intelligence_full.png",
      price: 8000,
      itemType: "Rune",
      id: "IntelligenceRune",
      rarity: 6,
      description: "get +50 point to intelligence"),
  "ManaRune": ShopItem(
      title: "Mana Rune",
      image: "assets/images/items/full/mana_full.png",
      price: 8000,
      itemType: "Rune",
      id: "ManaRune",
      rarity: 6,
      description: "get +50 point to Mana"),
  "VitalityRun": ShopItem(
      title: "Vitality Rune",
      image: "assets/images/items/full/vitality_full.png",
      price: 8000,
      itemType: "Rune",
      id: "VitalityRun",
      rarity: 6,
      description: "get +50 point to vitality"),
  //? Runes Items medium List
  "StrengthRuneMedium": ShopItem(
      title: "Strength Fragment",
      image: "assets/images/items/medium/strength_medium.png",
      price: 3000,
      itemType: "Rune",
      id: "StrengthRuneMedium",
      rarity: 5,
      description: "get +25 point to strength"),
  "SenseRuneMedium": ShopItem(
      title: "Sense Fragment",
      image: "assets/images/items/medium/sense_medium.png",
      price: 3000,
      itemType: "Rune",
      id: "SenseRuneMedium",
      rarity: 5,
      description: "get +25 point to sense"),
  "AgilityRuneMedium": ShopItem(
      title: "Agility Fragment",
      image: "assets/images/items/medium/agility_medium.png",
      price: 3000,
      itemType: "Rune",
      id: "AgilityRuneMedium",
      rarity: 5,
      description: "get +50 point to agility"),
  "IntelligenceRuneMedium": ShopItem(
      title: "Intelligence Fragment",
      image: "assets/images/items/medium/intelligence_medium.png",
      price: 3000,
      itemType: "Rune",
      id: "IntelligenceRuneMedium",
      rarity: 5,
      description: "get +25 point to intelligence"),
  "ManaRuneMedium": ShopItem(
      title: "Mana Fragment",
      image: "assets/images/items/medium/mana_medium.png",
      price: 3000,
      itemType: "Rune",
      id: "ManaRuneMedium",
      rarity: 5,
      description: "get +25 point to mana"),
  "VitalityRunMedium": ShopItem(
      title: "Vitality Fragment",
      image: "assets/images/items/medium/vitality_medium.png",
      price: 3000,
      itemType: "Rune",
      id: "VitalityRunMedium",
      rarity: 5,
      description: "get +25 point to vitality"),
  //? Runes Items small List
  "StrengthRuneSmall": ShopItem(
      title: "Strength Shard ",
      image: "assets/images/items/small/strength_small.png",
      price: 2000,
      itemType: "Rune",
      id: "StrengthRuneSmall",
      rarity: 4,
      description: "get +10 point to strength"),
  "SenseRuneSmall": ShopItem(
      title: "Sense Shard ",
      image: "assets/images/items/small/sense_small.png",
      price: 2000,
      itemType: "Rune",
      id: "SenseRuneSmall",
      rarity: 4,
      description: "get +10 point to sense"),
  "AgilityRuneSmall": ShopItem(
      title: "Agility Shard ",
      image: "assets/images/items/small/agility_small.png",
      price: 2000,
      itemType: "Rune",
      id: "AgilityRuneSmall",
      rarity: 4,
      description: "get +10 point to agility"),
  "IntelligenceRuneSmall": ShopItem(
      title: "Intelligence Shard ",
      image: "assets/images/items/small/intelligence_small.png",
      price: 2000,
      itemType: "Rune",
      id: "IntelligenceRuneSmall",
      rarity: 4,
      description: "get +10 point to intelligence"),
  "ManaRuneSmall": ShopItem(
      title: "Mana Shard ",
      image: "assets/images/items/small/mana_small.png",
      price: 2000,
      itemType: "Rune",
      id: "ManaRuneSmall",
      rarity: 4,
      description: "get +10 point to mana"),
  "VitalityRunSmall": ShopItem(
      title: "Vitality Shard ",
      image: "assets/images/items/small/vitality_small.png",
      price: 2000,
      itemType: "Rune",
      id: "VitalityRunSmall",
      rarity: 4,
      description: "get +10 point to vitality"),
};

// the function use the rarity property to count the droop rate of the item (the higher the rarity the lesser the chance is)
// this function only handle the runes
List<dynamic> getRandomItems(int count) {
  List<dynamic> randomItems = []; // storing the items later in

  List<dynamic> itemsByRarity = archive.values.toList();
  itemsByRarity.shuffle(); // Shuffle to ensure randomness based on rarity

  for (int i = 0; i < itemsByRarity.length; i++) {

    if (itemsByRarity[i].itemType != "frame" &&
        itemsByRarity[i].itemType != "Box") {
      int dropProbability = 100 ~/
          itemsByRarity[i].rarity; // Adjust drop probability based on rarity

      if (itemsByRarity[i].rarity == 6) {
        dropProbability = dropProbability ~/
            2; // Double drop probability for items with rarity 6
      }
      if (Random().nextInt(100) < dropProbability) {
        randomItems.add(itemsByRarity[i]);
        if (randomItems.length == count) break;
      }
    }
  }
  //return a list of 6 items type runes for shop page
  return randomItems;
}

// the frame function, have the same idea as the pervious one
List<dynamic> getRandomFrames(int count) {
  List<dynamic> randomItems = [];

  List<dynamic> itemsByRarity = archive.values.toList();
  itemsByRarity.shuffle(); // Shuffle to ensure randomness based on rarity

  for (int i = 0; i < itemsByRarity.length; i++) {

    // here will work if the type is frame only
    if (itemsByRarity[i].itemType == "frame") {
      int dropProbability = 100 ~/
          itemsByRarity[i].rarity; // Adjust drop probability based on rarity

      if (itemsByRarity[i].rarity == 6) {
        dropProbability = dropProbability ~/
            2; // Double drop probability for items with rarity 6
      }
      if (Random().nextInt(100) < dropProbability) {
        randomItems.add(itemsByRarity[i]);
        if (randomItems.length == count) break;
      }
    }
  }
  return randomItems;
}

// the function is responsible for geeing the coins randomly from the coin bag 
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