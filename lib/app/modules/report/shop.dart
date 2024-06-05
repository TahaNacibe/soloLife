import 'dart:async';
import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/core/utils/items_archive.dart';
import 'package:SoloLife/app/data/models/achievements.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/shopItem.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

List<dynamic> todayListIds = ProfileProvider().readProfile().todayShop;
List<dynamic> items = archive.values
    .toList()
    .where((element) => todayListIds.contains(element.id))
    .toList();
List<dynamic> frames =
    items.where((element) => element.itemType == "frame").toList();
List<dynamic> runes =
    items.where((element) => element.itemType == "Rune").toList();
List<dynamic> box =
    archive.values.where((element) => element.itemType == "Box").toList();

//final Profile user = ProfileProvider().readProfile();

class _ShopState extends State<Shop> {
  int coins = 0;
  String _timeDifference = "";
  @override
  void initState() {
    Profile user2 = ProfileProvider().readProfile();
    coins = user2.coins;
    if(mounted){

    _calculateTimeDifference();
    }
    super.initState();
  }

  bool show = false;
  void _calculateTimeDifference() {
    Timer.periodic(Duration(seconds: 1), (_) {
      DateTime now = DateTime.now();
      DateTime midnight = DateTime(now.year, now.month, now.day + 1);
      Duration difference = midnight.difference(now);
      // Extract hours and minutes
      int hours = difference.inHours;
      int minutes = difference.inMinutes.remainder(60);
      setState(() {
        _timeDifference = '${hours}h ${minutes}m';
      });
    });
  }

  // get user data as var user
  int infoIndexRune = 99999;
  int infoIndexBox = 99999;
  Profile user = ProfileProvider().readProfile();
  @override
  Widget build(BuildContext context) {
    coins = user.coins;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            ProfileProvider().readProfile();
            ShopProvider().readTodayList();
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Shop",
              style: TextStyle(
                  fontFamily: "Quick",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
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
                            padding: EdgeInsets.only(left: 8, right: 8, top: 4),
                            child: Text(
                              'Items Shop',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Quick",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 20, left: 8, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.pushNamed(
                                      context, "Inventory");
                                  setState(() {
                                    coins = result as int;
                                    user.coins = coins;
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.indigo.withOpacity(.6)),
                                    child: Icon(
                                      Icons.backpack_outlined,
                                      size: 25,
                                      color: Colors.white,
                                    ))),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.orange, width: 1.5)),
                              child: Row(
                                children: [
                                  Text(
                                    "  ${user.coins}  ",
                                    style: TextStyle(
                                        fontFamily: "Quick",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Icon(
                                        IconPack.rune_stone,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: "Reset in ",
                          ),
                          TextSpan(
                            text: "${_timeDifference}",
                            style: TextStyle(
                              color: Colors.indigo
                            )
                          )
                        ]),
                        style: TextStyle(
                            fontFamily: "Quick",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Divider(),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        color: Theme.of(context).cardColor,
                        child: Text(
                          "Items:",
                          style: TextStyle(
                              fontFamily: "Quick",
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        )),
                  ],
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: frames.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: .7, crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    ShopItem item = frames[index];
                    bool isOwned = user.inventory.contains(item.id);
                    return shopItemFrameCard(item, isOwned);
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Divider(),
                    Container(
                        padding: EdgeInsets.all(8),
                        color: Theme.of(context).cardColor,
                        child: Text(
                          "Runes:",
                          style: TextStyle(
                              fontFamily: "Quick",
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        )),
                  ],
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: runes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: .7, crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    ShopItem item = runes[index];
                    bool isOwned = user.inventory.contains(item.id);
                    return GestureDetector(
                        onLongPress: () {
                          infoIndexRune == index
                              ? infoIndexRune = 99999
                              : infoIndexRune = index;
                          setState(() {});
                        },
                        child: shopItemRuneCard(
                            item, isOwned, index == infoIndexRune));
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Divider(),
                    Container(
                        padding: EdgeInsets.all(8),
                        color: Theme.of(context).cardColor,
                        child: Text(
                          "Box:",
                          style: TextStyle(
                              fontFamily: "Quick",
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        )),
                  ],
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: box.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: .7, crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    ShopItem item = box[index];
                    bool isOwned = user.inventory.contains(item.id);
                    return GestureDetector(
                        onLongPress: () {
                          infoIndexBox == index
                              ? infoIndexBox = 99999
                              : infoIndexBox = index;
                          setState(() {});
                        },
                        child: shopItemRuneCard(
                            item, isOwned, index == infoIndexBox));
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Divider(),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blue.withOpacity(.6), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(.1), // Shadow color
                        spreadRadius: 1, // Extends the shadow beyond the box
                        blurRadius: 5, // Blurs the edges of the shadow
                        offset: const Offset(
                            0, 3), // Moves the shadow slightly down and right
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor.withOpacity(.95),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/items/box/runsBag.png",
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            user.inventory.add("CoinsBag");
                            ProfileProvider().saveProfile(user, "", context);
                            achievementsHandler("coins", context);
                            setState(() {});
                          },
                          child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue
                                          .withOpacity(.1), // Shadow color
                                      spreadRadius:
                                          1, // Extends the shadow beyond the box
                                      blurRadius:
                                          5, // Blurs the edges of the shadow
                                      offset: const Offset(0,
                                          3), // Moves the shadow slightly down and right
                                    )
                                  ],
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                "Watch an Ad ",
                                style: TextStyle(
                                    fontFamily: "Quick",
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget shopItemFrameCard(ShopItem item, bool isOwned) {
    int rarity = item.rarity;
    int price = item.price;
    String id = item.id;
    Color color = rarity == 3
        ? Colors.blue
        : rarity == 4
            ? Colors.purple
            : rarity == 5
                ? Colors.orange
                : Colors.red;
    String text = "Owned";
    // set free for 0$ items
    String priceTag = item.price != 0 ? "${item.price}" : "Free";
    // the Ui for the Frame item Card
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
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
            border: Border.all(color: color.withOpacity(.6)),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Container(
                  child: Image.asset(
                    item.image,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor, // Shadow color
                        spreadRadius: 1, // Extends the shadow beyond the box
                        blurRadius: 5, // Blurs the edges of the shadow
                        offset: const Offset(
                            0, 3), // Moves the shadow slightly down and right
                      )
                    ],
                    color: color.withOpacity(.65),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15), bottom: Radius.circular(15))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: GestureDetector(
                        onTap: () {
                          // in case buying new item you don't have
                          if (!isOwned && user.coins >= price) {
                            user.inventory.add(id);
                            user.coins = user.coins - price;
                            snack("item was added to your inventory", false);
                            achievementsHandler("orv2", context);
                            ProfileProvider().saveProfile(user, "", context);
                            achievementsHandler("coins", context);
                            setState(() {});
                            // you have the item in your inventory
                          } else if (isOwned) {
                            snack("You Already have that Frame", false);
                          } else {
                            snack("need More coins", true);
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 18),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: isOwned
                                        ? Colors.grey.withOpacity(.3)
                                        : Colors.white
                                            .withOpacity(.3), // Shadow color
                                    spreadRadius:
                                        1, // Extends the shadow beyond the box
                                    blurRadius:
                                        5, // Blurs the edges of the shadow
                                    offset: const Offset(0,
                                        3), // Moves the shadow slightly down and right
                                  )
                                ],
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              isOwned ? text : priceTag,
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
    );
  }

  Widget shopItemRuneCard(ShopItem item, bool isOwned, bool showInfo) {
    int rarity = item.rarity;
    int price = item.price;
    String id = item.id;
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
              width: MediaQuery.sizeOf(context).width / 3.5,
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
                padding: EdgeInsets.all(8),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        image,
                        width: 80,
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
                              top: Radius.circular(15),
                              bottom: Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: GestureDetector(
                          onTap: () {
                            if (user.coins >= price) {
                              user.inventory.add(id);
                              user.coins = user.coins - price;
                              coins - price;
                              ProfileProvider().saveProfile(user, "", context);
                              achievementsHandler("coins", context);
                              snack("item was added to your inventory", false);
                              setState(() {});
                            } else {
                              snack("need More coins", true);
                            }
                          },
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
                                    fontSize:
                                        item.title.contains("Box") ? 13.5 : 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
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
                                fontSize: 14),
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

// fast snack bar action
  void snack(String text, bool failed) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: failed ? Colors.orange : Colors.green,
        content: Text(text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Quick",
            )));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
