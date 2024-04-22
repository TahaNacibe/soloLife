import 'dart:async';
import 'dart:io';
import 'package:SoloLife/app/core/values/jobs.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/expScal/exp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:path_provider/path_provider.dart';

class UserInfoCard extends StatefulWidget {
  const UserInfoCard({super.key});

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  late File _imageFile;
  bool isThere = false;
  bool theme = false;
  @override
  void initState() {
     theme = ThemeProvider().loadTheme();
    super.initState();
    _loadImage();
  }
  
  Future<void> _loadImage() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDirectory.path}/profile_image.png';

    if (await File(filePath).exists()) {
      setState(() {
        _imageFile = File(filePath);
        isThere = true;
      });
    }else{
      setState(() {
        _imageFile = File("");
        isThere = false;
      });
    }
  }


  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String filePath = '${appDirectory.path}/profile_image.png';

      await imageFile.copy(filePath);

      setState(() {
        _imageFile = File(filePath);
      });
    }
  }

  bool isExpanded = false;
  bool hide = false;
      bool intOrNot = false;

  @override
  Widget build(BuildContext context) {
    _loadImage();
    // get user data as var user
    final Profile user = ProfileProvider().readProfile();
    // get user level
    int level = user.level;
    // get user current exp
    int exp = user.exp;
    // get this level exp cap
    int expCap = getExpToNextLevel(level);
    // user authority list (moods that are activated)
    List<dynamic> keys = user.keys!;
    // get user name
    String userName = user.userName;
    // get user rank
    String rank = user.rank;
    // get user class
    String UserClass = user.job;
    // check if master 
    bool checkMaster = keys.contains('master');
    // get user States 
    UserState state = StatesProvider().readState();
    //ger class grade
int counterClass() {
  int counter = 0;
  user.counter.forEach((e) {
    if (e.containsKey('${user.job}')) {
      counter = e['${user.job}'];
    }
  });
  return counter;
}
int counterNumber = counterClass();
    
    
    // color getter for ranks 
Color getRankColor(String rank) {
  switch (rank) {
    case "E":
      return Colors.brown[600]!; // Assign bronze color for "E"
    case "D":
      return Colors.green;
    case "C":
      return Colors.blue;
    case "B":
      return Colors.orange;
    case "A":
      return Colors.red; 
    case "S":
      return Colors.yellow; // Assign teal color for "S"
    case "SS":
      return Colors.teal; // Assign indigo color for "SS"
    case "SSS":
      return Colors.indigo; // Assign pink color for "SSS"
    case "Z":
      return Colors.purple;
    default:
      return Colors.grey; // default color
  }
}

    //
    void fastSave(){
    state.points = state.points -1;
    StatesProvider().writeState(state);
    setState((){});
    }
    void snack(String text,bool failed){
      final snackBar = SnackBar(
      backgroundColor: failed? Colors.orange :Colors.green,
      content: Text(text,
      style: TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: "Quick",
    )));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    void jobUpdate(){
      String selectedJob = weightedRandomSelection(jobs);
      updateClass(selectedJob);
      print("${counterClass()}");
      snack("New Class $selectedJob bones:${classReword(selectedJob)['message']}", false);
    }

    void dialogBox(){
       Dialogs.materialDialog(
    msg: 'changing Class cost 40 point are you sure? ',
          title: "Change Class",
          customView: Text("the previous class effect won't be canceled",style: TextStyle(color: Colors.red),),
          customViewPosition: CustomViewPosition.BEFORE_ACTION,
          titleStyle: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.bold,fontSize: 20,color: Colors.red),
          msgStyle: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.w600,fontSize: 16),
          color: Theme.of(context).cardColor,
          context: context,
          actions: [
            IconsOutlineButton(
              onPressed: () {
                snack("Canceled by Player", true);
                Navigator.pop(context);
              },
              text: 'Cancel',
              iconData: Icons.cancel_outlined,
              textStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
              iconColor: Colors.blue,
            ),
            IconsOutlineButton(
              onPressed: () {
                state.points = state.points - 40;
                StatesProvider().writeState(state);
                jobUpdate();
                Navigator.pop(context);
              },
              text: 'Change',
              iconData: Icons.delete,
              color: Colors.green,
              textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              iconColor: Colors.white,
            ),
          ]);
                                                                
    }



    return Padding(
        padding: const EdgeInsets.all(12),
        //? the expanded card
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: isExpanded? 520 : 220,
          decoration:BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black.withOpacity(.2)),
          color: Theme.of(context).cardColor,
          boxShadow:[BoxShadow(
          color: Theme.of(context).shadowColor, // Shadow color
          spreadRadius: 1, // Extends the shadow beyond the box
          blurRadius: 5, // Blurs the edges of the shadow
          offset: const Offset(0, 3), // Moves the shadow slightly down and right
          )]
          ),
          child:  Padding(
            padding: const EdgeInsets.all(8.0),
            //? stack for having the button to show and hide
            child: Stack(alignment: Alignment.bottomCenter,
              children: [
                Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Stack(alignment: Alignment.bottomRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                      onTap:(){
                                            _pickImage(ImageSource.gallery);
                                      },
                                child: Container(
                                
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 5,
                                    color:getRankColor(rank),),
                                  shape: BoxShape.circle
                                ),
                                
                                  child: CircleAvatar(
                                            radius: 35,
                                            backgroundImage: isThere 
                                                ? FileImage(_imageFile)
                                                : AssetImage('assets/images/giphy.gif') as ImageProvider,
                                                 ),
                                ),
                              ),
                            ),
                             //? the Rank budget 
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(padding: const EdgeInsets.all(8),
                                                decoration:BoxDecoration(
                                                color:getRankColor(rank) ,
                                                shape: BoxShape.circle
                                              ),
                                                child: Text("$rank",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Quick",
                                                  fontSize: 16,color:Colors.white),)),
                          ),
                          ],
                        ),
                        Padding(
                    padding: const EdgeInsets.only(left:6),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width*.65),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontFamily: "Quick",fontSize:23),
                            TextSpan(children: [
                              TextSpan(
                                //? the user state
                                text:checkMaster? "Master" : "Player",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              //? user name
                              TextSpan(
                                text: " $userName",
                                style: TextStyle(
                                  color:checkMaster? Colors.red : Colors.blue,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ])),
                            Row(
                              children: [
                                Container(padding: const EdgeInsets.all(6),
                                                    decoration:BoxDecoration(
                                                    color:const Color.fromARGB(255, 28, 39, 201).withOpacity(.7),
                                                    borderRadius: BorderRadius.circular(15)
                                                  ),
                                                    child: Text("Level:$level",
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,color:Colors.white),)),
                                                      GestureDetector(
                                                        onTap:(){
                                                          print(user.counter);
                                                          if(UserClass == "Empty" && level >= 5){
                                                            jobUpdate();
                                                          }else if(level < 5){
                                                            snack("Classes are available after level 5", true);
                                                          }else if(UserClass != "empty"){
                                                            if(state.points >= 40){
                                                              dialogBox();
                                                            }else{
                                                              snack("required 40 point to change class", true);
                                                            }
                                                            
                                                          }
                                                        },
                                                        onLongPressEnd:(_){
                                                          intOrNot = !intOrNot;
                                                          setState(() {
                                                            
                                                          });
                                                        },
                                                        child: Stack(alignment: Alignment.centerRight,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                                              child: Container(padding: const EdgeInsets.all(6),
                                                              decoration:BoxDecoration(
                                                              border: Border.all(
                                                                width: 2,
                                                                color: Colors.blue),
                                                              borderRadius: BorderRadius.circular(15)
                                                                                                                      ),
                                                              child: Text.rich(TextSpan(
                                                                children:[TextSpan(
                                                                  text:  "$UserClass  "
                                                                ),
                                                                TextSpan(
                                                                  text:intOrNot? "$counterNumber": "${convertToRomanNumeral(counterNumber)}",
                                                                  style: TextStyle(color:colorGater(counterNumber)   )
                                                                )])
                                                               ,
                                                              style:  TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,color: Colors.blue),)),
                                                            ),
                                                                  
                                                          ],
                                                        ),
                                                      ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                      ],
                    ),
                  
                    const Divider(color: Colors.transparent,),
                        //? the exp bar widget
                    Padding(
                      padding: const EdgeInsets.only(top:8),
                      child: expBar(exp,expCap,context,theme),
                    ),
                    //? exp value / exp cap
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(alignment:Alignment.centerRight,
                        child: Text("$exp/$expCap",
                        style:const TextStyle(fontWeight: FontWeight.bold,fontFamily: "Quick"),)),
                    ),         
                    //? user keys
                      if(hide)
                      Padding(
                        padding: const EdgeInsets.only(bottom:8),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: keys.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            childAspectRatio: 2,
                            crossAxisCount: 5), 
                          itemBuilder: (context,index){
                            return authorityItems(keys[index]);
                          }),
                      ),
                        //? user points
                        if(hide)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text.rich(TextSpan(
                                          children:[const TextSpan(
                                            text: "Total Points : ",
                                            style:TextStyle(
                                              fontFamily: "Quick",)
                                          ),TextSpan(
                                            text: "${state.points}",
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 18)
                                          )]),
                                        style:const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                        SizedBox(width: 20,),
                                         Container(padding: EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.orange),
                                                      borderRadius: BorderRadius.circular(15)
                                                    ),
                                                      child: GestureDetector(
                                                        onTap:(){
                                                          final snackBar = SnackBar(
                                                            backgroundColor: rankManager()['change']? Colors.green : Colors.orange,
                                                            content: Text("Rank Up :${rankManager()['rank']}",
                                                            style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Quick",
                                                          )));
                                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                        }, child: Text("Rank Up",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Quick",
                                                          color:Colors.orange),)),
                                                    )
                                      ],
                                    ),
                                  ),
                                   Divider(color: Theme.of(context).iconTheme.color!.withOpacity(.4),),
                                  // supposed to be !hide but for somehow that worked
                                  //? user states
                        if(hide)
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:8.0,top:8),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Your States :",
                                  style:TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Quick"),),
                                  userStates("Agility",state.agility,(){
                                    state.agility = state.agility + 1;
                                    fastSave();
                                  },state),
                                  userStates("Intelligence",state.intelligence,(){
                                    state.intelligence = state.intelligence + 1;
                                    fastSave();
                                  },state),
                                  userStates("Sense",state.sense,(){
                                    state.sense = state.sense + 1;
                                    fastSave();
                                  },state),
                                ],),
                            ),
                              Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  userStates("Strength",state.strength,(){
                                    state.strength = state.strength + 1;
                                    fastSave();
                                  },state),
                                  userStates("Vitality",state.vitality,(){
                                    state.vitality = state.vitality + 1;
                                    fastSave();
                                  },state),
                                  userStates("Mana",state.mana,(){
                                    state.mana = state.mana + 1;
                                    fastSave();
                                  },state),
                                ],),
                              )
                          ],
                        )
                  ],),
                  //? the show more or less button
                  Container(decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle
                  ),
                    child: TextButton(onPressed: (){
                      int time = !hide? 500 : 0;
                          isExpanded = !isExpanded;
                          setState((){});
                          Future.delayed(Duration(milliseconds: time)).then((_){
                            hide = !hide;
                            setState((){});
                          });
                        }, child: Icon(
                          !hide
                          ? Icons.keyboard_double_arrow_down
                          : Icons.keyboard_double_arrow_up,
                          color: Theme.of(context).iconTheme.color,)),
                  )
              ],
            ),
          ),),
      );
  }
}

//? the exp bar widget
Widget expBar(int currentExp,int maxExp,BuildContext context,bool theme){
  double size = getWidth(maxExp, currentExp,MediaQuery.sizeOf(context).width);
  Color color =theme?  const Color.fromARGB(255, 133, 39, 176) :Color.fromARGB(255, 33, 65, 243);
  return Container(
    decoration: BoxDecoration(
      color:Colors.grey.withOpacity(.2),
      borderRadius: BorderRadius.circular(15)
    ),
    width: MediaQuery.sizeOf(context).width,
    height: 10,
    child: Row(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration:BoxDecoration(
            
            gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(.9), // Light blue
                      color.withOpacity(0.5), // Deep blue
                      color.withOpacity(0.4), // Black
                    ],
                  ),
            borderRadius: BorderRadius.circular(15)
          ),
          height: 8,
          width:size<40? size : size-40,
          
        ),
      ],
    ),);
}

//? get the exp bar total width to get the current exp width
double getWidth(int maxExp,int currentExp,double width){
  double result = ((currentExp*width)/maxExp);
  return result;
}

//? user keys budge widget
Widget authorityItems(String name){
  bool isMaster = name == "master";
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      border: Border.all(color: isMaster? Colors.red : Colors.blue),
      borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Text(name,
        style: TextStyle(
          fontSize: 16,
          color: isMaster? Colors.red : Colors.blue,
          fontWeight: FontWeight.bold,
          fontFamily: "Quick"),),
      ),);
}

//? user state widget budge
Widget userStates(String name,int count,void Function() onTap,UserState userPoint){
  int point = userPoint.points;
  Color color =  count >=1000? Colors.purple :count >= 500? Colors.red : count >= 100? Colors.yellow: Colors.blue;
  return GestureDetector(
    onTap: point >0? onTap : (){},
        
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Container(padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
      borderRadius:BorderRadius.circular(15),
      border: Border.all(color: color)),
        child: Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Text.rich(
            maxLines: 1,
            
            overflow: TextOverflow.ellipsis,
          style:const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16),
            TextSpan(children:[
              TextSpan(
              text: "$name : ",
              style:const TextStyle(
              fontFamily: "Quick",
              )
            ),
            TextSpan(
              text: "$count",
              style:  TextStyle(
                color:color,
                fontSize: 16)
            )])),
            
        ],),
      ),
    ),
  );
}