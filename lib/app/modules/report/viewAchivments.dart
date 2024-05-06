
import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/voiceCommand/service.dart';
import 'package:SoloLife/app/modules/report/viewRepot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {

  @override
  Widget build(BuildContext context) {
    
    UserState states = StatesProvider().readState();
    return Scaffold(
      appBar: AppBar(),
      body:ListView(children: [
        Image.asset(
                  width: 120,
                  height: 120,
                  "assets/images/trophy.png"),
                                       
        Padding(
              padding: const EdgeInsets.all(12),
              child: Text("Titles :",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,fontFamily: "Quick"),),
            ),
            //Todo change to grid view builder
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: 
              SliverGridDelegateWithFixedCrossAxisCount(
               // childAspectRatio: 0.5,
                crossAxisSpacing: 8,
                mainAxisExtent: 50,
                mainAxisSpacing: 8,
                crossAxisCount: 2),
              children: [
                //basic titles 
                Text("basic titles",style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 18),),
                Divider(),
                titleBar("Born Of a Mage", states.mana, 75, Colors.blue, context, "Mana"),
                titleBar("The Basis of Sense", states.sense, 75, Colors.blue, context, "Sense"),
                titleBar("The Core of Life", states.vitality, 75, Colors.blue, context, "Vitality"),
                titleBar("Foundation of Power", states.strength, 75, Colors.blue, context, "Strength"),
                titleBar("Basis of Mind", states.intelligence, 75, const Color.fromARGB(255, 75, 162, 233), context, "Intelligence"),
                titleBar("beginning of Agility", states.agility, 75, Colors.blue, context, "Agility"),
                //advance titles
                Text("advance titles",style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 18),),
                Divider(),
                titleBar("The Great Mage", states.mana, 200, Colors.red, context, "Mana"),
                titleBar("The rule of Perception", states.sense, 200, Colors.red, context, "Sense"),
                titleBar("Into immortality", states.vitality, 200, Colors.red, context, "Vitality"),
                titleBar("Body Of Steal", states.strength, 200, Colors.red, context, "Strength"),
                titleBar("Master of Mind", states.intelligence, 200, Colors.red, context, "Intelligence"),
                titleBar("Protector of Agility", states.agility, 200, Colors.red, context, "Agility"),
                //master titles
                Text("master titles",style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 18),),
                Divider(),
                titleBar("The anchor of Mana", states.mana, 1000, Colors.purple, context, "Mana"),
                titleBar("The anchor of Sense", states.sense, 1000, Colors.purple, context, "Sense"),
                titleBar("The anchor of Strength", states.strength, 1000, Colors.purple, context, "Strength"),
                titleBar("The anchor of Intelligence", states.intelligence, 1000, Colors.purple, context, "Intelligence"),
                titleBar("The anchor of Vitality", states.vitality, 1000, Colors.purple, context, "Vitality"),
                titleBar("The anchor of Agility", states.agility, 1000, Colors.purple, context, "Agility"),
                Text("monarch titles",style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 18),),
                Divider(),
                titleBarMax("The Origin of World", states, Colors.teal, context),
                ],),
            )
      ],),
    );
  }
}

