import 'dart:io';

import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/data/models/achivments.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/voiceCommand/service.dart';
import 'package:SoloLife/app/settings/dialogAlert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
    bool showMoods = false;
    Profile user = ProfileProvider().readProfile();
    bool list = false;
    List<String> defaultKeys = ["reverse","master","solo","dream","manager","monster","voltage"];
  @override
  Widget build(BuildContext context) {
    String message = user.achievements.contains("box")? "You can handel most actions here or use the box command" : "You can handel most actions here or ■ ■ ■ ■";
    bool mood = ThemeProvider().loadTheme();
    bool frame = user.framePath.isEmpty;
    return PopScope(
      canPop: false,
        onPopInvoked: (didPop) async {
  if (didPop) {
    return;
  }else{
    Navigator.popAndPushNamed(context, "HomePage");
  }
        },child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed:(){
            Navigator.popAndPushNamed(context, "HomePage");
          }, icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
            //stings title
             Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(padding: EdgeInsets.all(15),
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
                            Stack(alignment: Alignment.centerLeft,
                      children: [
                        Divider(),
                        Container(
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(message,
                              style: TextStyle(
                                fontFamily: "Quick",
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding:EdgeInsets.symmetric(horizontal: 12),
                    child: Stack(alignment: Alignment.centerLeft,
                      children: [
                        Divider(),
                        Container(
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Menu',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),),
            //profile edit
            settingsItem("Edit User Info",(){
              Navigator.popAndPushNamed(context, "ProfileInformation");
            },IconPack.adult,""),
            //password manager
            settingsItem("Password and Security",(){
              Navigator.pushNamed(context, "Password");
            },Icons.lock,""),
            //dark mood toggle
            settingsItemSwitch("Dark Theme",
            "You may need to restart the app for the changes to take effects",
            mood
            ,Icons.sunny,(){
              setState(() {});
            }),
            //frame equip
            keysItem2("Use Frame", Icons.account_circle,
            (){
              setState(() {
                
              });
            },
            false,
            "Turn off To stop using the frames",
           ),
            //list mood toggle
            keysItem('list View',
            Icons.list,(){setState(() {});},
            false,"Switch between list and grid view in main page"),
            //tools section
            settingsItem("Tools",(){
              showMoods = !showMoods;
              setState(() {
                
              });
            },IconPack.coin,"see and manage all the tools from this panel"),
            if(showMoods)
            ListView.builder(
              itemCount: defaultKeys.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 20),
                  child: keysItem(defaultKeys[index],Icons.format_align_center_outlined,(){setState(() {
                    
                  });},true,""),
                );
              }),
            //erase all data
            settingsItem("Erase all the data",(){
              showCustomAlertDialog(
        context: context,
        title: 'Erase all the data',
        description: 'All your data will be erased',
        icon: Icons.warning,
        actionButton1Text: 'Cancel',
        actionButton2Text: 'Delete',
        actionButton1Callback: (){
      Navigator.pop(context);
        },
        actionButton2Callback: () {
          Profile user = ProfileProvider().readProfile();
      deleteFileFromDocumentsDirectory(user.pfpPath);
      deleteFileFromDocumentsDirectory(user.coverPath);
      eraseAll();
        },
      );
      
            },Icons.delete,"all your data will be deleted"),
            
            //info tab
            settingsItem("Version 1.0",(){},Icons.info,""),
            ],
          )),
      ),
    );
  }
  Widget keysItem(String title,IconData icon,void Function() refresh,bool isKey,String description){

    bool mood = user.keys!.contains(title);
    return StatefulBuilder(
      builder: (context,setState) {
        if(isKey){

        return Container(
          padding: EdgeInsets.all(14),
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
          child: ListTile(
            title: Text(title,
            style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 16)),
            leading: Icon(icon,size: 30,color: Colors.indigo,),
            trailing:(user.keys!.contains("dream") && title == "dream")
            ? Icon(Icons.lock,size: 30,color: Colors.blue,) 
            : SizedBox(
              width: 50,
              height: 25,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if(title.contains("dream") && !user.keys!.contains("dream")){
                      dreamProtocol(context);
                    }else if(title.contains("solo") && !user.keys!.contains("solo")){
                      soloProtocol(context);
                    }
                    mood? user.keys!.remove(title) : user.keys!.add(title);
                    ProfileProvider().saveProfile(user, "", context);
                    mood = !mood;
                    refresh;
                    setState(() {
                      
                    });
                    achievementsHandler("mood",context);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.6),
                  borderRadius: BorderRadius.circular(15)
                ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 50,
                        height: 25,
                        alignment: mood ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:mood ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),);
        }else{
          list = user.keys!.contains("list");
          return StatefulBuilder(
            builder: (context,setState) {
              return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                    child: Container(
                      padding: EdgeInsets.all(24),
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
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(Icons.grid_3x3),
                                ),
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(title,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 17),),
                                    SizedBox(
                                      width: 180,
                                      child: Text(
                                        description,
                                        style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.w500,fontSize: 15),),
                                    ),
                                  ],
                                )
                              ],),
                             GestureDetector(
              onTap: () {
                setState(() {
                  list = !list;
                  refresh;
                  !list? user.keys!.remove("list") :user.keys!.add("list");
                  ProfileProvider().saveProfile(user,"",context);
                  setState(() {
                    
                  });
                });
              },
              child: Container(
                decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.6),
                borderRadius: BorderRadius.circular(15)
              ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 50,
                      height: 25,
                      alignment: list ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:list ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                      )
                            ],
                          ),
                    ),
                  );
            }
          );
        }
      }
    );
  }
  Widget keysItem2(String title,IconData icon,void Function() refresh,bool isKey,String description){
          return StatefulBuilder(
            builder: (context,setState) {
          bool frame = user.framePath.isNotEmpty;
              return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                    child: Container(
                      padding: EdgeInsets.all(24),
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
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(icon),
                                ),
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(title,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 17),),
                                    SizedBox(
                                      width: 180,
                                      child: Text(
                                        description,
                                        style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.w500,fontSize: 15),),
                                    ),
                                  ],
                                )
                              ],),
                             GestureDetector(
              onTap: () {
                setState(() {
                  frame = !frame;
                  refresh;
                  user.framePath = "";
                  ProfileProvider().saveProfile(user,"",context);
                  setState(() {
                    
                  });
                });
              },
              child: Container(
                decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.6),
                borderRadius: BorderRadius.circular(15)
              ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 50,
                      height: 25,
                      alignment: frame ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:frame ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                      )
                            ],
                          ),
                    ),
                  );
            }
          );
        }
  Widget settingsItem(String title,void Function() navigator,IconData icon,String description){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      child: GestureDetector(
        onTap: navigator,
        child: Container(
          padding: EdgeInsets.all(24),
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
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(icon),
                          ),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(textAlign: TextAlign.left,
                                title,style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 16),),
                            if(description.isNotEmpty)
                            SizedBox(
                                  width: 230,
                                  child: Text(
                                    description,
                                    style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.w500,fontSize: 14),),
                                ),
                            ],
                          )
                        ],),
        ),
      ),
    );
  }

    Widget settingsItemSwitch(
      String title,
      String description,
      bool mood,
      IconData icon,
      VoidCallback onSwitch){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
      child: Container(
        padding: EdgeInsets.all(24),
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
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(icon),
                            ),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 16),),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    description,
                                    style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.w500,fontSize: 14),),
                                ),
                              ],
                            )
                          ],),
                         GestureDetector(
          onTap: () {
            setState(() {
              mood = !mood;
              onSwitch;
              ThemeProvider().toggleTheme();
              print("${ThemeProvider().loadTheme()}");
              setState(() {
                
              });
            });
          },
          child: Container(
            decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.6),
            borderRadius: BorderRadius.circular(15)
          ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 50,
                  height: 25,
                  alignment: mood ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:mood ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
                        ],
                      ),
      ),
    );
  }
}

void deleteFileFromDocumentsDirectory(String fileName) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String filePath = fileName;
  File file = File(filePath);
  try {
    if (await file.exists()) {
    await file.delete();
  }
  } catch (e) {
    print("$e");
  }
 
}