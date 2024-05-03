import 'package:SoloLife/app/core/utils/items_archive.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/shopItem.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

//! for test purposes only
List<dynamic> items = archive.values.toList();

class _ShopState extends State<Shop> {
      // get user data as var user
    final Profile user = ProfileProvider().readProfile();
  @override
  Widget build(BuildContext context) {
        // get user data as var user
    final Profile user = ProfileProvider().readProfile();
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap:(){
            user.coins = 9999999;
            ProfileProvider().saveProfile(user, "");
          },
          child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text("Shop",style: TextStyle(
                fontFamily: "Quick", 
                fontWeight: FontWeight.bold, 
                color: Colors.blue,
                fontSize: 20),),
            ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(children: [
            
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, "Inventory");
              },
              child: Text.rich(TextSpan(
                      children:[const TextSpan(
              text: "Your Credit : ",
              style:TextStyle(
                fontFamily: "Quick",)
                      ),TextSpan(
              text: "${user.coins}",
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 18)
                      )]),
                    style:const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
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
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder:(context, index){
            ShopItem item = items[index];
            bool isOwned = user.inventory.contains(item.id);
            if(item.itemType == "frame"){
            return shopItemFrameCard(item.title,item.image,item.price,isOwned,item.id);
            }else{
              return shopItemRuneCard(item.title,item.image,item.price,isOwned,item.id);
            }
          })
          ],),
        ),
      ),
    );
  }
Widget shopItemFrameCard(String title, String image, int price,bool isOwned, String id){
  // get the item state
  bool isOwned2 = user.inventory.contains(id);
  // text for the button
  String text =user.framePath != image? "Equip" : "Equipped";
  // set free for 0$ items
  String priceTag = price != 0? "$price" : "Free";
  // the Ui for the Frame item Card
  return ListTile(
    title: Text(title),
    subtitle: Text(priceTag),
    trailing: Image.asset(image),
    leading: TextButton(
      onPressed:(){
        // in case buying new item you don't have 
      if(!isOwned2 && user.coins >= price){
        user.inventory.add(id);
        user.coins = user.coins - price;
        snack("item was added to your inventory", false);
        user.framePath = image;
        ProfileProvider().saveProfile(user,"");
        setState(() {});
        // you have the item in your inventory
      }else if(isOwned2){
        if(user.framePath != image){
          text = "Equip";
          user.framePath = image;
        ProfileProvider().saveProfile(user,"");
        snack("Frame was Equipped", false);
        setState(() {});
        }else{
          text = "Equipped";
        }
        // you're brock and can't afford it
      }else{
        snack("need More coins", true);
      }
    } , child: Text(isOwned2? text :"buy",style: TextStyle(color: Theme.of(context).iconTheme.color),)),
  );
}

Widget shopItemRuneCard(String title, String image, int price,bool isOwned, String id){
  int number = 0;
  for (var item in user.inventory) {
    if(id == item){
      number+= 1;
    }
  }
  return ListTile(
    title: Text("$title x$number"),
    subtitle: Text("$price"),
    trailing: Image.asset(image),
    leading: TextButton(onPressed:(){
      if(user.coins >= price){
      user.inventory.add(id);
      user.coins = user.coins - price;
      ProfileProvider().saveProfile(user,"");
      snack("item was added to your inventory", false);
      setState((){});
      }else{
       snack("need More coins", true);
      }
    } , child: Text("buy",style: TextStyle(color: Theme.of(context).iconTheme.color),)),
  );
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
