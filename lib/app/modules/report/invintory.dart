import 'package:SoloLife/app/core/utils/items_archive.dart';
import 'package:SoloLife/app/core/values/item_drop.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/shopItem.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
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
      // get the Inventory items by their id 
List<ShopItem> items(List<dynamic> ids){
  List<ShopItem> result = [];
  for (String id in ids) {
    result.add(archive[id]);
  }
  return result;
}
// create empty map
Map<String, int> countMap = {};
// map through the list of ids and set counter in the map using entries
 user.inventory.forEach((element){
  // add one for each one
  countMap[element] = (countMap[element] ?? 0) +1;
});
// create list of the map entries we gathered before
List<MapEntry<String, int>> countList = countMap.entries.toList();
// dialog for using Runes
void dialogBox(String name, String id, String image){
  String attribute = name.replaceAll("Rune", "");
       Dialogs.materialDialog(
          customView: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(image),
              ),
              Text('Want to use $name now? '),
              Text("Gain $attribute +50",style: TextStyle(color: Colors.blue),),
            ],
          ),
          customViewPosition: CustomViewPosition.BEFORE_ACTION,
          titleStyle: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.bold,fontSize: 20,color: Colors.red),
          msgStyle: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.w600,fontSize: 16),
          color: Theme.of(context).cardColor,
          context: context,
          actions: [
            IconsOutlineButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'Cancel',
              iconData: Icons.cancel_outlined,
              textStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
              iconColor: Colors.blue,
            ),
            IconsOutlineButton(
              onPressed: () {
                addBones(id);
                user.inventory.remove(id);
                ProfileProvider().saveProfile(user,"");
                setState(() {});
                Navigator.pop(context);
              },
              text: 'Use',
              iconData: Icons.arrow_forward_ios,
              color: Colors.green,
              textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              iconColor: Colors.white,
            ),
          ]);
                                                                
    }

// Ui
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        Stack(alignment: Alignment.centerLeft,
          children: [
            Divider(thickness: 1.4,),
            Container(
              padding: EdgeInsets.all(8),
              color: Theme.of(context).cardColor,
              child: Text("Inventory", 
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Quick",
                fontWeight: FontWeight.w600),)),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: countList.length,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: 
          SliverGridDelegateWithFixedCrossAxisCount( 
            crossAxisCount: 3
          ), 
          itemBuilder: (context,index){
            ShopItem item = archive[countList[index].key];
            String count = countList[index].value == 1? "" : "x${countList[index].value }";
            return Padding(
              padding: const EdgeInsets.all(4),
              child: itemData(item.title,item.image,count,(){
                if(item.itemType == "Rune"){
                  dialogBox(item.title, countList[index].key, item.image);
                }else if(item.itemType == "Box"){
                  bottomShit(item.title, item.image,(){setState(() {
                    
                  });},item.id);
                }
                
              }),
            );
            //
          })
      ],),
    );

  }
  Widget itemData(String name, String image, String count, void Function() onTap){
    return GestureDetector(
      onTap:
          onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
          boxShadow:[BoxShadow(
            color: Theme.of(context).shadowColor, // Shadow color
            spreadRadius: 1, // Extends the shadow beyond the box
            blurRadius: 5, // Blurs the edges of the shadow
            offset: const Offset(0, 3), // Moves the shadow slightly down and right
            )]
        ),
        child: Stack(alignment: Alignment.center,
          children: [
            Image.asset(image),
            //Divider(),
            Align(alignment: Alignment.bottomCenter,
              child: Container(color: Colors.white.withOpacity(.4),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.w600),
                    children:[
                    TextSpan(text: name),
                    TextSpan(text:count,style: TextStyle(color: Colors.green))
                  ])),
              ),
            )
          ],
        )),
    );
  }

  void bottomShit(String BoxType, String image, void Function() refresh,String id){
    String selectedItem = "";
    ShopItem selectedItemRow = ShopItem(title: "Item", image: "image", price: 0, itemType: "", id: "id",rarity: 3);
     showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context,setState) {
                    return Container(
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(image),
                            Text(BoxType),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                 // Example usage
                    
                    
                      // Select one item based on its probability
                      itemProbabilities = BoxType.contains("Old")? oldItemProbabilities : BoxType.contains("Curse")? curseItemProbabilities : itemProbabilities;
                      selectedItem = selectItemByProbability(itemProbabilities);
                      selectedItemRow = archive[selectedItem];
                      selectedItem = selectedItemRow.title;
                      user.inventory.remove(id);
                      ProfileProvider().saveProfile(user, "");
                      if(selectedItemRow.itemType != 'frame'){
                        user.inventory.add(selectedItemRow.id);
                      }
                      setState(() {
                        
                      });
                      refresh();
                              },
                              child: Text('open',style: TextStyle(color: Colors.black),),
                            ),
                            Text("item:$selectedItem (probability:${itemProbabilities[selectedItemRow.id]})")
                          ],
                        ),
                      ),
                    );
                  }
                );
              },
            );
  }
}

void addBones(String id){
  //get user States 
UserState state = StatesProvider().readState(); 
    switch (id) {
      //in case Agility Rune
      case "AgilityRune":
      state.agility = state.agility+ 50;
      StatesProvider().writeState(state);

      // in case Intelligence Rune
      case "IntelligenceRune":
      state.intelligence = state.intelligence+ 50;
      StatesProvider().writeState(state);

      // in case mana Rune
      case "ManaRune":
      state.mana = state.mana+ 50;
      StatesProvider().writeState(state);

      // in case Strength Rune
      case "StrengthRune":
      state.strength = state.strength+ 50;
      StatesProvider().writeState(state);

      // in case Vitality Rune
      case "VitalityRun":
      state.vitality = state.vitality+ 50;
      StatesProvider().writeState(state);

      //In case Sense Rune
      case "SenseRune":
      state.sense = state.sense+ 50;
      StatesProvider().writeState(state);
    }
}