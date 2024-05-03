import 'dart:async';
import 'dart:io';
import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/core/values/jobs.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/expScal/exp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

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
    // get frame
    String frame = user.framePath;
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

  String formatNumber(int number) {
  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(1)}B'; // Billion
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M'; // Million
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K'; // Thousand
  } else {
    return number.toString();
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
              iconData: Icons.change_circle,
              color: Colors.green,
              textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              iconColor: Colors.white,
            ),
          ]);
                                                                
    }



    return Padding(
        padding: const EdgeInsets.all(8),
        //? the expanded card
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: isExpanded? 560 : 290,
          decoration:BoxDecoration(
            
            //border: Border.all(color: Colors.black.withOpacity(.2)),
          //color: Theme.of(context).cardColor,
          /*
          boxShadow:[BoxShadow(
          color: Theme.of(context).shadowColor, // Shadow color
          spreadRadius: 1, // Extends the shadow beyond the box
          blurRadius: 5, // Blurs the edges of the shadow
          offset: const Offset(0, 3), // Moves the shadow slightly down and right
          )]
          */
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
                        GestureDetector(
                                      onTap:(){
                                            _pickImage(ImageSource.gallery);
                                      },
                          child: Stack(alignment: Alignment.bottomRight,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 5,
                                    color:frame != ""? Colors.transparent :getRankColor(rank),),
                                  shape: BoxShape.circle
                                ),
                                
                                  child: CircleAvatar(
                                            radius: 40,
                                            backgroundImage: isThere 
                                                ? FileImage(_imageFile)
                                                : AssetImage('assets/images/giphy.gif') as ImageProvider,
                                                 ),
                                ),
                              ),
                               //? the Rank budget 
                               if(frame != "")
                            Image.asset(frame,width: 100, height:100,fit: BoxFit.cover, ),
                                
                            ],
                          ),
                        ),
                        Padding(
                    padding: const EdgeInsets.only(left:6),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width*.64),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontFamily: "Quick",fontSize:20),
                                TextSpan(children: [
                                  //? user name
                                  TextSpan(
                                    text: " $userName",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  if(checkMaster)
                                  TextSpan(
                                    //? the user state
                                    text:" (Master)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:Colors.red,
                                    )
                                  ),
                                ])),
                                 Padding(
                           padding: const EdgeInsets.all(6),
                           child: Container(padding: const EdgeInsets.all(6),
                                                          decoration:BoxDecoration(
                                                          color:const Color.fromARGB(255, 28, 39, 201).withOpacity(.7),
                                                          borderRadius: BorderRadius.circular(15)
                                                        ),
                                                          child: Text("Lv.$level",
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,color:Colors.white),)),
                         ),
                            ],
                          ),
                             
                            Padding(
                              padding: const EdgeInsets.only(top:5),
                              child: StepProgressIndicator(
                                totalSteps: 100,
                                roundedEdges: Radius.circular(15),
                                currentStep: steps(exp, expCap),
                                size: 8,
                                padding: 0,
                                selectedGradientColor: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [Color.fromARGB(255, 47, 33, 243).withOpacity(0.7), Color.fromARGB(255, 114, 39, 176).withOpacity(0.7)],
                                            ),
                                            unselectedGradientColor: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [Color.fromARGB(255, 33, 37, 243).withOpacity(0.2), Color.fromARGB(255, 87, 39, 176).withOpacity(.2)],
                                            ),
                              ),
                            ),
                           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                                  
                             Padding(
                                                         padding: const EdgeInsets.all(0),
                                                         child: Align(alignment:Alignment.bottomRight,
                                child: Text("$exp/$expCap",
                                style:const TextStyle(fontWeight: FontWeight.bold,fontFamily: "Quick"),)),
                                                       ),
                             ],
                           ),
                            
                            /*Padding(
                              padding: const EdgeInsets.only(bottom:6),
                              child: Divider(color: Theme.of(context).iconTheme.color!.withOpacity(.1),),
                            ),*/
                        ],
                      ),
                    ),
                  ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 8),
                      child: Divider(),
                    ),
                    Container(padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).cardColor,
                          boxShadow:[BoxShadow(
                          color: Theme.of(context).shadowColor, // Shadow color
                          spreadRadius: 1, // Extends the shadow beyond the box
                          blurRadius: 5, // Blurs the edges of the shadow
                          offset: const Offset(0, 3), // Moves the shadow slightly down and right
                          )]
                        ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                    onTap: (){
                                      snack("Your Current Player Rank", false);
                                    },child: actionBarItem("Rank",rank,getRankColor(rank),false)),
                            GestureDetector(
                                                        onTap:(){
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
                                                          setState((){});
                                                        },
                                                        child: actionBarItem("Class",UserClass,colorGater(counterNumber),true)),
                            actionBarItem("Tools","${user.keys!.length}",Theme.of(context).iconTheme.color!,false),
                            actionBarItem("Credit","${formatNumber(user.coins)}",Colors.orange,false),                       
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap:(){
                        int time = !hide? 500 : 0;
                          isExpanded = !isExpanded;
                          setState((){});
                          Future.delayed(Duration(milliseconds: time)).then((_){
                            hide = !hide;
                            setState((){});
                          });
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).cardColor,
                          boxShadow:[BoxShadow(
                          color: Theme.of(context).shadowColor, // Shadow color
                          spreadRadius: 1, // Extends the shadow beyond the box
                          blurRadius: 5, // Blurs the edges of the shadow
                          offset: const Offset(0, 3), // Moves the shadow slightly down and right
                          )]
                        ),
                        child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Player Details", style:TextStyle(
                            fontFamily: "Quick",
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                          Icon(Icons.info_outline_rounded)
                        ],),),
                    ),
                  ),    
                    //? user keys
                      if(hide)
                      Container(padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).cardColor,
                          boxShadow:[BoxShadow(
                          color: Theme.of(context).shadowColor, // Shadow color
                          spreadRadius: 1, // Extends the shadow beyond the box
                          blurRadius: 5, // Blurs the edges of the shadow
                          offset: const Offset(0, 3), // Moves the shadow slightly down and right
                          )]
                        ),
                        child: Column(
                          children: [
                            if(false)
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: keys.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
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
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text.rich(TextSpan(
                                            children:[const TextSpan(
                                              text: "Points : ",
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
                                    
                                     //Divider(color: Theme.of(context).iconTheme.color!.withOpacity(.4),),
                                    // supposed to be !hide but for somehow that worked
                                    //? user states
                                    Padding(
                                      padding: const EdgeInsets.only(left:8),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                           Text("States ($UserClass ${intOrNot? "" : convertToRomanNumeral(counterNumber)}):",
                                          style:TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Quick"),),
                                          Divider(color: Theme.of(context).iconTheme.color!.withOpacity(.2),),
                                        ],
                                      ),
                                    ),
                        if(hide)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:8.0,top:8),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
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
                          ],
                        ),
                      ),
                        
                                 
                        
                  ],),
                 /* //? the show more or less button
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
                  )*/
              ],
            ),
          ),),
      );
  }
}
int steps(int exp, int cap) {
  double newSteps = (exp * 100) /cap; // Divide cap by a factor
  int result = newSteps.round();
  return result;
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
  Color color =  count >=1000? Colors.purple :count >= 500? Colors.red : count >= 100? Colors.orange: Colors.blue;
  return GestureDetector(
    onTap: point >0? onTap : (){},
        
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Container(padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
      borderRadius:BorderRadius.circular(15),
      border: Border.all(color: color, width: 1.4)),
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

Widget actionBarItem(String title, String count,Color color, bool isIcon){
  return Column(
    children: [
      if(isIcon)
      Padding(
        padding: const EdgeInsets.only(bottom:2),
        child: Icon(getClassIcon(count),color: color,),
      ),
      Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          children:[
            if(!isIcon)
            TextSpan(
              text: "$count\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color.withOpacity(.7),
                fontSize: 19,
                )
            ),
            TextSpan(
              text: "$title"
            )]),
        style: TextStyle(
          fontFamily: "Quick",
          fontWeight:FontWeight.bold),),
    ],
  );
}
IconData getClassIcon(String name){
  IconData icon = Icons.abc_rounded;
  if(name == "Ranger"){
    return IconPack.crossbow;
  }else if(name == "Fighter"){
    return IconPack.fist_raised;
  }else if(name == "Tanker"){
    return IconPack.shield;
  }else if(name == "Mage"){
    return IconPack.crystal_wand;
  }else if(name == "Healer"){
    return IconPack.health;
  }else if(name == "Assassin"){
    return IconPack.bowie_knife;
  }else if(name == "Necromancer"){
    return IconPack.skull;
  }else{
    return icon;
  }
}
/*
Row(
                              children: [
                                
                                Stack(
                                  children: [
                                   GestureDetector(
                                    onTap: (){
                                      snack("Your Current Player Rank", false);
                                    },
                                     child: Container(padding: const EdgeInsets.all(8),
                                                                            decoration:BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            color:getRankColor(rank) ,
                                                                            //shape: BoxShape.circle,
                                                                            boxShadow:[BoxShadow(
                                                    color: getRankColor(rank).withOpacity(.4), // Shadow color
                                                    spreadRadius: 1, // Extends the shadow beyond the box
                                                    blurRadius: 5, // Blurs the edges of the shadow
                                                    offset: const Offset(0, 3), // Moves the shadow slightly down and right
                                                    )]
                                                                          ),
                                                                            child: Text("Pr-$rank",
                                                                            style: const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: "Quick",
                                                                              fontSize: 15,color:Colors.white),)),
                                   ),
                                  ],
                                ),
                                                      GestureDetector(
                                                        onTap:(){
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
                                                          setState((){});
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
                                                                  text:  "$UserClass "
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
                            ),*/