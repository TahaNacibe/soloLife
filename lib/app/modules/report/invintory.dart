import 'dart:math';

import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/core/utils/items_archive.dart';
import 'package:SoloLife/app/core/values/item_drop.dart';
import 'package:SoloLife/app/data/models/achivments.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/shopItem.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  // get user data as var user
  final Profile user = ProfileProvider().readProfile();

  @override
  Widget build(BuildContext context) {
    // create empty map to count occurrences of each item
    Map<String, int> countMap = {};

    // iterate through the user's inventory to count occurrences of each item
    for (String itemId in user.inventory) {
      // add one for each occurrence of the item
      if (archive[itemId] != null) {
        countMap[itemId] = (countMap[itemId] ?? 0) + 1;
      }
    }

    // convert the map entries to a list for easier access
    List<MapEntry<String, int>> countList = countMap.entries.toList();
    List<MapEntry<String, int>> filteredCountList = countList
        .where((entry) => (archive[entry.key].itemType != 'frame'))
        .toList();
    int count = filteredCountList.fold(0, (sum, entry) => sum + entry.value);
    // UI
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          Navigator.pop(context, user.coins);
        },
        child: ListView(
          children: [
            //stings title
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor, // Shadow color
                        spreadRadius: 1, // Extends the shadow beyond the box
                        blurRadius: 5, // Blurs the edges of the shadow
                        offset: const Offset(
                            0, 3), // Moves the shadow slightly down and right
                      )
                    ]),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Divider(),
                        Container(
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Inventory',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              //Profile user1 = ProfileProvider().readProfile();
                              Navigator.pop(context, user.coins);
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 3)),
                              child: Icon(Icons.close),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: Colors.orange, width: 1.5)),
                            child: Row(
                              children: [
                                Text(
                                  "  ${user.coins}  ",
                                  style: TextStyle(
                                      fontFamily: "Quick",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      IconPack.rune_stone,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: Colors.indigo, width: 1.5)),
                            child: Row(
                              children: [
                                Text(
                                  "  ${count} ",
                                  style: TextStyle(
                                      fontFamily: "Quick",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      IconPack.basket,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Divider(),
                  Container(
                      padding: EdgeInsets.all(12),
                      color: Theme.of(context).cardColor,
                      child: Text(
                        "Hello There (0o0)/",
                        style: TextStyle(
                            fontFamily: "Quick",
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      )),
                ],
              ),
            ),
            // other UI widgets
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: filteredCountList.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  // get the item and its count at the current index
                  String itemId = filteredCountList[index].key;
                  int itemCount = filteredCountList[index].value;

                  // find the corresponding item in the archive
                  ShopItem item = archive[itemId];

                  // build the widget for the item
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: itemData(
                      item.title,
                      item.image,
                      itemCount.toString(),
                      () {
                        if (item.itemType == "Rune") {
                          bottomShitRune(item.title, item.image, () {
                            achievementsHandler("state", context);
                            setState(() {});
                          }, itemId, item.description);
                        } else if (item.itemType == "Box") {
                          bottomShitBox(item.title, item.image, () {
                            setState(() {});
                          }, itemId);
                        } else if (item.itemType == 'coins') {
                          return bottomShitBag(
                              "coins", item.image, () {}, item.id);
                        }
                      },
                      item.rarity,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemData(String name, String image, String count,
      void Function() onTap, int rarity) {
    Color color = rarity == 3
        ? Colors.blue
        : rarity == 4
            ? Colors.purple
            : rarity == 5
                ? Colors.orange
                : Colors.red;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  //border: Border.all(color: color.withOpacity(.2),width: 1.5),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor, // Shadow color
                      spreadRadius: 1, // Extends the shadow beyond the box
                      blurRadius: 5, // Blurs the edges of the shadow
                      offset: const Offset(
                          0, 3), // Moves the shadow slightly down and right
                    )
                  ]),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: color.withOpacity(.7),
                        borderRadius: BorderRadius.circular(15)),
                  ),

                  //Divider(),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: color.withOpacity(.8),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "x$count",
                            style: TextStyle(
                                fontFamily: "Quick",
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                      ])),
                    ),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(image),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      name,
                      style: TextStyle(
                          fontFamily: "Quick", fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showImageDialogBox(bool haveImage, BuildContext context, String title,
      String imageUrl, bool isNew,
      [IconData icon = IconPack.rune_stone]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Quick"),
          ),
          content: Container(
            height: !haveImage ? 100 : 200, // Adjust the height as needed
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (haveImage)
                  Image.asset(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                if (!haveImage)
                  Icon(
                    icon,
                    size: 100,
                  ),
                if (isNew)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15))),
                      child: Text(
                        "New",
                        style: TextStyle(
                            fontFamily: "Quick",
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )
              ],
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setState(() {});
              },
              child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    'Close',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Quick",
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  )),
            ),
          ],
        );
      },
    );
  }

  void bottomShitBox(
      String BoxType, String image, void Function() refresh, String id) {
    String selectedItem = "";
    bool isNew = false;
    ShopItem selectedItemRow = ShopItem(
        title: "Item",
        image: "image",
        price: 0,
        itemType: "",
        id: "id",
        rarity: 3);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(BoxType,
                      style: TextStyle(
                          fontFamily: "Quick",
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Image.asset(
                    image,
                    width: 200,
                    height: 200,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Divider(),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        // Select one item based on its probability
                        selectedItem = selectItemByRarity(BoxType);
                        selectedItemRow = archive[selectedItem];
                        user.inventory.remove(id);
                        ProfileProvider().saveProfile(user, "", context);
                        isNew = !user.inventory.contains(selectedItemRow.id);
                        if (selectedItemRow.itemType == 'frame' &&
                                !user.inventory.contains(selectedItem) ||
                            selectedItemRow.itemType != 'frame') {
                          user.inventory.add(selectedItemRow.id);
                        }
                        Navigator.pop(context);
                        showImageDialogBox(true, context, selectedItemRow.title,
                            selectedItemRow.image, isNew);
                        setState(() {});
                        refresh();
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(color: Colors.blue, width: 1.5)),
                          child: Text(
                            'open Box',
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: "Quick",
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void bottomShitBag(
      String BoxType, String image, void Function() refresh, String id) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Runes",
                      style: TextStyle(
                          fontFamily: "Quick",
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Icon(
                    IconPack.rune_stone,
                    size: 100,
                  ),
                  Text(
                    "20 ~~ 1000 Runes can drop",
                    style: TextStyle(
                        fontFamily: "Quick",
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Divider(),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        // Select one item based on its probability
                        int result = getRandomNumber();
                        user.inventory.remove(id);
                        user.coins = user.coins + result;
                        ProfileProvider().saveProfile(user, "", context);
                        Navigator.pop(context);
                        showImageDialogBox(false, context,
                            "You Got $result ruins", image, false);
                        setState(() {});
                        refresh();
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(color: Colors.blue, width: 1.5)),
                          child: Text(
                            'open Bag',
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: "Quick",
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void runeAction(String name) {
    List<String> parts = name.split(" ");
    int value = parts[1] == "Rune"
        ? 50
        : parts[1] == "Fragment"
            ? 25
            : 10;
    UserState state = StatesProvider().readState();
    void refresh() {
      StatesProvider().writeState(state);
      setState(() {});
    }

    switch (parts[0]) {
      case "Sense":
        state.sense += value;
        refresh();
      case "Strength":
        state.strength += value;
        refresh();
      case "Intelligence":
        state.intelligence += value;
        refresh();
      case "Mana":
        state.mana += value;
        refresh();
      case "Agility":
        state.agility += value;
        refresh();
      case "Vitality":
        state.vitality += value;
        refresh();
      default:
    }
  }

  void bottomShitRune(String BoxType, String image, void Function() refresh,
      String id, String description) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(children: [
                        TextSpan(
                          text: "$BoxType\n",
                        ),
                        TextSpan(text: description)
                      ]),
                      style: TextStyle(
                          fontFamily: "Quick",
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Image.asset(
                    image,
                    width: 180,
                    height: 180,
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        // Select one item based on its probability
                        user.inventory.remove(id);
                        ProfileProvider().saveProfile(user, "", context);
                        //ToDo : the function handling the states for each stone
                        runeAction(BoxType);
                        Navigator.pop(context);
                        int value = description.contains("+50")
                            ? 50
                            : description.contains("+25")
                                ? 25
                                : 10;
                        showImageDialogBox(
                            false,
                            context,
                            "$BoxType was Used State will be raised by $value",
                            image,
                            false,
                            IconPack.trophy);
                        setState(() {});
                        refresh();
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(color: Colors.blue, width: 1.5)),
                          child: Text(
                            'Use Rune now',
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: "Quick",
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget shopItemRuneCard(ShopItem item, bool isOwned, bool showInfo) {
    int rarity = item.rarity;
    String description = item.description;
    Color color = rarity == 3
        ? Colors.blue
        : rarity == 4
            ? Colors.purple
            : rarity == 5
                ? Colors.orange
                : Colors.red;
    String image = item.image;
    // set free for 0$ items
    String priceTag = item.price != 0 ? "${item.price}" : "Free";
    // the Ui for the Frame item Card
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: color.withOpacity(.1)),
                  color: color.withOpacity(.2),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor, // Shadow color
                      spreadRadius: 1, // Extends the shadow beyond the box
                      blurRadius: 5, // Blurs the edges of the shadow
                      offset: const Offset(
                          0, 3), // Moves the shadow slightly down and right
                    )
                  ]),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: color.withOpacity(.8)),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(.1), // Shadow color
                      spreadRadius: 1, // Extends the shadow beyond the box
                      blurRadius: 5, // Blurs the edges of the shadow
                      offset: const Offset(
                          0, 3), // Moves the shadow slightly down and right
                    )
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).cardColor.withOpacity(.95),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: Image.asset(
                        image,
                        width: 100,
                        height: 80,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Theme.of(context).shadowColor, // Shadow color
                              spreadRadius:
                                  1, // Extends the shadow beyond the box
                              blurRadius: 5, // Blurs the edges of the shadow
                              offset: const Offset(0,
                                  3), // Moves the shadow slightly down and right
                            )
                          ],
                          color: color.withOpacity(.65),
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                              bottom: Radius.circular(15))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4, top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${item.rarity}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 18),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white
                                              .withOpacity(.3), // Shadow color
                                          spreadRadius:
                                              1, // Extends the shadow beyond the box
                                          blurRadius:
                                              5, // Blurs the edges of the shadow
                                          offset: const Offset(0,
                                              3), // Moves the shadow slightly down and right
                                        )
                                      ],
                                      border: Border.all(
                                          color: Colors.white, width: 1.5),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Text(
                                    priceTag,
                                    style: TextStyle(
                                        fontFamily: "Quick",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(6),
                child: Text(
                  "${item.title}",
                  style: TextStyle(
                    fontFamily: "Quick",
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
            if (showInfo)
              Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: color.withOpacity(1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.info, color: Colors.white),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
          ],
        ));
  }
}

String selectItemByRarity(String type) {
  int split = type.contains("Curse")
      ? 3
      : type.contains("Old")
          ? 2
          : 1;
  // Adjusted rarity weights
  Map<String, double> adjustedWeights = {};

  // Adjusted weights for each rarity level
  double weight3 = 4.0; // Adjust this value for rarity 3
  double weight4 = 4.0 / split; // Adjust this value for rarity 4
  double weight5 = 2.0 / split; // Adjust this value for rarity 5
  double weight6 = 1.0 / split; // Adjust this value for rarity 6

  // Assign adjusted weights based on rarity
  Map<String, ShopItem> newArchive =
      Map.from(archive); // Create a copy to avoid modifying the original map
  newArchive.removeWhere((key, value) => value.itemType == "Box");
  for (var entry in newArchive.entries) {
    int rarity = entry.value.rarity;
    if (rarity == 3) {
      adjustedWeights[entry.key] = weight3;
    } else if (rarity == 4) {
      adjustedWeights[entry.key] = weight4;
    } else if (rarity == 5) {
      adjustedWeights[entry.key] = weight5;
    } else if (rarity == 6) {
      adjustedWeights[entry.key] = weight6;
    }
  }

  // Calculate total adjusted weight
  double totalAdjustedWeight = adjustedWeights.values.reduce((a, b) => a + b);

  // Generate a random number between 0 and totalAdjustedWeight
  double randomWeight = Random().nextDouble() * totalAdjustedWeight;

  // Iterate through items and find the one whose adjusted rarity range contains the random number
  double cumulativeWeight = 0;
  for (var entry in adjustedWeights.entries) {
    cumulativeWeight += entry.value;
    if (randomWeight <= cumulativeWeight) {
      return entry.key;
    }
  }

  // Should never reach here, but return a default item just in case
  return newArchive.keys.first;
}
