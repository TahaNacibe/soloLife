import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/core/utils/items_archive.dart';
import 'package:SoloLife/app/data/models/achivments.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/shopItem.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

Profile user = ProfileProvider().readProfile();
List<dynamic> items = archive.values.toList();
List<dynamic> frames =items.where((element) => element.itemType == "frame").toList();
List<dynamic> runes =items.where((element) => element.itemType == "Rune").toList();
List<dynamic> box = archive.values.where((element) => element.itemType == "Box").toList();



class _ShopState extends State<Shop> {
                      bool show = false;

      // get user data as var user
    final Profile user = ProfileProvider().readProfile();
    int infoIndex = 99999;
  @override
  Widget build(BuildContext context) {
        // get user data as var user
    final Profile user = ProfileProvider().readProfile();
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: const EdgeInsets.all(8.0),
            child: Text("Shop",style: TextStyle(
              fontFamily: "Quick", 
              fontWeight: FontWeight.bold, 
              fontSize: 20),),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(children: [
            
            Padding(
              padding: const EdgeInsets.only(bottom:20,left: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                GestureDetector(
                            onTap:(){
                              
                              Navigator.pushNamed(context, "Inventory");
                            },child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.indigo.withOpacity(.6)
                            ),
                              child: Icon(Icons.backpack_outlined,size: 30,color: Colors.white,))),
               Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color:Colors.orange,width: 1.5)),
                    child: Row(children: [
                      Text("  ${user.coins}  ",
                      style: TextStyle(
                        fontFamily: "Quick",
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20)
                      ),
                        child: Icon(IconPack.rune_stone,color: Colors.white,))
                    ],),
                  ),
              ],),
            ),
                Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Stack(alignment: Alignment.center,
            children: [
              Divider(),
              Container(
                padding: EdgeInsets.all(8),
                color: Theme.of(context).cardColor,
                child: Text("Items:",style: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.w700,fontSize: 18),)),
            ],
          ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: frames.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: .7,
                    crossAxisCount: 3), 
                  itemBuilder: (context,index){
                    ShopItem item = frames[index];
                    bool isOwned = user.inventory.contains(item.id);
                    return shopItemFrameCard(item,isOwned);
                  }),
                  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Stack(alignment: Alignment.centerLeft,
            children: [
              Divider(),
              Container(
                padding: EdgeInsets.all(8),
                color: Theme.of(context).cardColor,
                child: Text("Runes:",style: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.w700,fontSize: 18),)),
            ],
          ),
                ),
                  GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: runes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: .7,
                    crossAxisCount: 3), 
                  itemBuilder: (context,index){
                    ShopItem item = runes[index];
                    bool isOwned = user.inventory.contains(item.id);
                    return GestureDetector(
                      onLongPress:(){
                        infoIndex == index? infoIndex = 99999 : infoIndex = index;
                        setState(() {});
                      },
                      child: shopItemRuneCard(item,isOwned,index == infoIndex));
                  }),
                Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Stack(alignment: Alignment.centerLeft,
            children: [
              Divider(),
              Container(
                padding: EdgeInsets.all(8),
                color: Theme.of(context).cardColor,
                child: Text("Box:",style: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.w700,fontSize: 18),)),
            ],
          ),
                ),
                  GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: box.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: .7,
                    crossAxisCount: 3), 
                  itemBuilder: (context,index){
                    ShopItem item = box[index];
                    bool isOwned = user.inventory.contains(item.id);
                    return GestureDetector(
                      onLongPress:(){
                        infoIndex == index? infoIndex = 99999 : infoIndex = index;
                        setState(() {});
                      },
                      child: shopItemRuneCard(item,isOwned,index == infoIndex));
                  }),
                  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Stack(alignment: Alignment.centerLeft,
            children: [
              Divider(),
              
            ],
          ),
                ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                    child: Container(
                      decoration: BoxDecoration(
                         border: Border.all(color:Colors.blue.withOpacity(.6),width: 2),
                                    boxShadow:[BoxShadow(
                                color: Colors.blue.withOpacity(.1), // Shadow color
                                spreadRadius: 1, // Extends the shadow beyond the box
                                blurRadius: 5, // Blurs the edges of the shadow
                                offset: const Offset(0, 3), // Moves the shadow slightly down and right
                                )],
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).cardColor.withOpacity(.95), 
                      ),
                      child: Row(
                        
                        children: [
                        Image.asset("assets/images/items/box/runsBag.png",width: 100,height: 100,),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){
                            user.inventory.add("CoinsBag");
                            ProfileProvider().saveProfile(user, "",context);
                            achievementsHandler("coins",context);
                            setState(() {
                              
                            });
                          },
                          child: Container(
                            padding:EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              boxShadow:[BoxShadow(
                                  color: Colors.blue.withOpacity(.1), // Shadow color
                                  spreadRadius: 1, // Extends the shadow beyond the box
                                  blurRadius: 5, // Blurs the edges of the shadow
                                  offset: const Offset(0, 3), // Moves the shadow slightly down and right
                                  )],
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15)
                          ),
                            child: Text("Watch an Ad to get ruins bag",
                            style: TextStyle(
                              fontFamily: "Quick",
                              fontWeight: FontWeight.bold),)),
                        )
                      ],),
                    ),
                  )
          ],),

          
        ),
      ),
    );
  }
Widget shopItemFrameCard(ShopItem item,bool isOwned){
  int rarity = item.rarity;
  int price = item.price;
  String id = item.id;
  Color color = rarity == 3? Colors.blue: rarity == 4? Colors.purple :rarity == 5? Colors.orange : Colors.red;
  String image = item.image;
  String text =user.framePath != image? "Equip" : "Equipped";
  // set free for 0$ items
  String priceTag = item.price != 0? "${item.price}" : "Free";
  // the Ui for the Frame item Card
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(.1)),
      color: color.withOpacity(.2),      
      borderRadius: BorderRadius.circular(15),    
        boxShadow:[BoxShadow(
            color: Theme.of(context).shadowColor, // Shadow color
            spreadRadius: 1, // Extends the shadow beyond the box
            blurRadius: 5, // Blurs the edges of the shadow
            offset: const Offset(0, 3), // Moves the shadow slightly down and right
            )]
      ),
      child: Container(
      decoration: BoxDecoration(
        border: Border.all(color:color.withOpacity(.6)),
                boxShadow:[BoxShadow(
            color: color.withOpacity(.1), // Shadow color
            spreadRadius: 1, // Extends the shadow beyond the box
            blurRadius: 5, // Blurs the edges of the shadow
            offset: const Offset(0, 3), // Moves the shadow slightly down and right
            )],
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).cardColor.withOpacity(.95),
      ),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Padding(
            padding: const EdgeInsets.only(top:6),
            child: Container(
              child: Image.asset(item.image,width: 100,height: 80,),),
          ),
          Container(decoration: BoxDecoration(
                  boxShadow:[BoxShadow(
            color: Theme.of(context).shadowColor, // Shadow color
            spreadRadius: 1, // Extends the shadow beyond the box
            blurRadius: 5, // Blurs the edges of the shadow
            offset: const Offset(0, 3), // Moves the shadow slightly down and right
            )],
                  color: color.withOpacity(.65),
                  borderRadius: BorderRadius.vertical(top:Radius.circular(30),bottom: Radius.circular(15))
              ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom:4,top:4),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${item.rarity}",style: TextStyle(color:Colors.white),),
                            Icon(Icons.star,color: Colors.white,)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: GestureDetector(
                                onTap: (){
                                               // in case buying new item you don't have 
                              if(!isOwned && user.coins >= price){
                                user.inventory.add(id);
                                user.coins = user.coins - price;
                                snack("item was added to your inventory", false);
                                user.framePath = image;
                                ProfileProvider().saveProfile(user,"",context);
                                achievementsHandler("coins",context);
                                setState(() {});
                                               // you have the item in your inventory
                              }else if(isOwned){
                                if(user.framePath != image){
                          text = "Equip";
                          user.framePath = image;
                                ProfileProvider().saveProfile(user,"",context);
                                snack("Frame was Equipped", false);
                                setState(() {});
                                }else{
                          text = "Equipped";
                                }
                                               // you're brock and can't afford it
                              }else{
                                snack("need More coins", true);
                              }
                          } ,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical:6,horizontal: 18),
                    decoration: BoxDecoration(
                      boxShadow:[BoxShadow(
                                 color:isOwned? Colors.grey.withOpacity(.3) : Colors.white.withOpacity(.3), // Shadow color
                                 spreadRadius: 1, // Extends the shadow beyond the box
                                 blurRadius: 5, // Blurs the edges of the shadow
                                 offset: const Offset(0, 3), // Moves the shadow slightly down and right
                              )],
                                  border: Border.all(color:Colors.white,width: 1.5),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: Text(isOwned? text : priceTag,
                                style: TextStyle(
                                  fontFamily: "Quick",
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white ),)),
                            ),
                    )
                  ],
                ),
              )      ,
          
        ],),
      ),
    ),
  );
}

Widget shopItemRuneCard(ShopItem item,bool isOwned,bool showInfo){
  int rarity = item.rarity;
  int price = item.price;
  String id = item.id;
  String description = item.description;
  Color color = rarity == 3? Colors.blue: rarity == 4? Colors.purple :rarity == 5? Colors.orange : Colors.red;
  String image = item.image;
  // set free for 0$ items
  String priceTag = item.price != 0? "${item.price}" : "Free";
  // the Ui for the Frame item Card
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Stack(alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(.1)),
          color: color.withOpacity(.2),      
          borderRadius: BorderRadius.circular(15),    
            boxShadow:[BoxShadow(
                color: Theme.of(context).shadowColor, // Shadow color
                spreadRadius: 1, // Extends the shadow beyond the box
                blurRadius: 5, // Blurs the edges of the shadow
                offset: const Offset(0, 3), // Moves the shadow slightly down and right
                )]
          ),
          child: Container(
          decoration: BoxDecoration(
            border: Border.all(color:color.withOpacity(.8)),
                    boxShadow:[BoxShadow(
                color: color.withOpacity(.1), // Shadow color
                spreadRadius: 1, // Extends the shadow beyond the box
                blurRadius: 5, // Blurs the edges of the shadow
                offset: const Offset(0, 3), // Moves the shadow slightly down and right
                )],
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).cardColor.withOpacity(.95),
          ),
            child: Column(mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Container(
                child: Image.asset(image,width: 100,height: 80,),),
                    Container(decoration: BoxDecoration(
                      boxShadow:[BoxShadow(
                color: Theme.of(context).shadowColor, // Shadow color
                spreadRadius: 1, // Extends the shadow beyond the box
                blurRadius: 5, // Blurs the edges of the shadow
                offset: const Offset(0, 3), // Moves the shadow slightly down and right
                )],
                      color: color.withOpacity(.65),
                      borderRadius: BorderRadius.vertical(top:Radius.circular(30),bottom: Radius.circular(15))
                  ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:4,top:4),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${item.rarity}",style: TextStyle(color:Colors.white),),
                              Icon(Icons.star,color: Colors.white,)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: GestureDetector(
                                  onTap: (){
                                            if(user.coins >= price){
                                      user.inventory.add(id);
                                      user.coins = user.coins - price;
                                      ProfileProvider().saveProfile(user,"",context);
                                      achievementsHandler("coins",context);
                                      snack("item was added to your inventory", false);
                                      setState((){});
                                      }else{
                                      snack("need More coins", true);
                                      }
                              } ,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical:6,horizontal: 18),
                                    decoration: BoxDecoration(
                                      boxShadow:[BoxShadow(
                                     color: Colors.white.withOpacity(.3), // Shadow color
                                     spreadRadius: 1, // Extends the shadow beyond the box
                                     blurRadius: 5, // Blurs the edges of the shadow
                                     offset: const Offset(0, 3), // Moves the shadow slightly down and right
                                  )],
                                      border: Border.all(color:Colors.white,width: 1.5),
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Text(priceTag,
                                    style: TextStyle(
                                      fontFamily: "Quick",
                                      fontWeight: FontWeight.bold,
                                      color:Colors.white ),)),
                                ),
                        )
                      ],
                    ),
                  )      ,
              
            ],),
          ),
        ),
                Container(
                  padding: EdgeInsets.all(6),
                  child: Text("${item.title}",
                  style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,),
                  maxLines: 1,overflow: TextOverflow.ellipsis,)),
                  if(showInfo)
        Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(1),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.info,color:Colors.white),
                    Text(description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),),
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
void snack(String text,bool failed){
      final snackBar = SnackBar(
        duration: Duration(seconds: 1),
      backgroundColor: failed? Colors.orange :Colors.green,
      content: Text(text,
      style: TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: "Quick",
    )));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
}
