import 'dart:io';

import 'package:SoloLife/app/core/utils/items_archive.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/shopItem.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({super.key});

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

  Profile user = ProfileProvider().readProfile();
class _ProfileInformationState extends State<ProfileInformation> {
  late File pfpPath;
  bool isThere = false;
  // ---------------
  late File coverPath;
  bool isThereCover = false;
  // -------------------
  String frame = user.framePath;
  // -------------
  int length = 0;
  // --------------
  TextEditingController controller = TextEditingController();
    Future<void> _loadImage() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDirectory.path}/pfp_image.png';
    if (await File(filePath).exists()) {
      setState(() {
        pfpPath = File(filePath);
        isThere = true;
      });
    }else{
      setState(() {
        pfpPath = File("");
        isThere = false;
      });
    }
  }
    Future<File> _loadImageNow() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDirectory.path}/pfp_image.png';
      setState(() {
        pfpPath = File(filePath);
        isThere = true;
      });
      return pfpPath;
  }
    Future<void> _loadCover() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDirectory.path}/cover_image.png';
    if (await File(filePath).exists()) {
      print("==============yes");
      setState(() {
        coverPath = File(filePath);
        isThereCover = true;
      });
    }else{
      print("=======================no");
      setState(() {
        coverPath = File("");
        isThereCover = false;
        print("=========================$isThereCover");
      });
    }
  }
  Future<List<File>> loadCoverNow() async{
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDirectory.path}/cover_image.png';
    final Directory appDirectory2 = await getApplicationDocumentsDirectory();
    final String filePath2 = '${appDirectory2.path}/pfp_image.png';
    coverPath = File(filePath2);
    File pfpPath = File(filePath);
    if(await coverPath.exists()){
      print("==================true ddddd");
        isThere = true;
    }
    if(await pfpPath.exists()){
      print("======================true too");
      isThereCover = true;
    }
        print([coverPath,pfpPath]);
        print("===================$isThere =========== $isThereCover");
        return [coverPath,pfpPath];
  }




Future<void> _pickImage(ImageSource source,VoidCallback refresh) async {
  final pickedFile = await ImagePicker().pickImage(source: source);

  if (pickedFile != null) {
    final File imageFile = File(pickedFile.path);
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDirectory.path}/pfp_image.png';

    await imageFile.copy(filePath);

      coverPath = File(filePath);
      isThereCover = true; // Update state to indicate that the image is present
    setState(() {
    });
    refresh();
  }
}
Future<void> _pickImageCover(ImageSource source,VoidCallback refresh) async {
  final pickedFile = await ImagePicker().pickImage(source: source);

  if (pickedFile != null) {
    final File imageFile = File(pickedFile.path);
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDirectory.path}/cover_image.png';

    await imageFile.copy(filePath);

      coverPath = File(filePath);
      isThereCover = true; // Update state to indicate that the image is present
    setState(() {
    });
        refresh;

  }
    refresh;
}

Future<void> _pickImageCover1(ImageSource source,VoidCallback refresh) async {
  final pickedFile = await ImagePicker().pickImage(source: source);

  if (pickedFile != null) {
    final File imageFile = File(pickedFile.path);
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDirectory.path}/pfp_image.png';

    await imageFile.copy(filePath);

      pfpPath = File(filePath);
      isThere = true; // Update state to indicate that the image is present
    setState(() {
    });
        refresh;

  }
    refresh;
}
  @override
  void initState() {
    _loadImage();
    _loadCover();
    super.initState();
  }
  Widget build(BuildContext context,) {
    controller.text = user.userName;
    Widget cover(bool isThereCover,File path){
      if(isThereCover) {

         print("===============yes2");
            
            return Container(
              height: 220,
              width: MediaQuery.sizeOf(context).width,
              child: Image.file(path,fit: BoxFit.cover,));

      }else{
        print("========================no2");
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))
          ),
          height: 220,
          width: MediaQuery.sizeOf(context).width,
          child: Image.asset(
            'assets/images/giphy.gif',
            fit: BoxFit.cover,
            ));
      }
    }
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap:(){
            Navigator.popAndPushNamed(context, "HomePage");
          },
          child: Icon(Icons.arrow_back)),
        centerTitle:true,
        title: Text( "Profile Information",style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold),),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
  if (didPop) {
    return;
  }else{
    Navigator.popAndPushNamed(context, "HomePage");
  }
        },
        child: StatefulBuilder(
          builder: (context,setState) {
            return StreamBuilder(
              stream: loadCoverNow().asStream(),
              builder: (context,snapshot) {
                
                if(snapshot.connectionState == ConnectionState.waiting || snapshot.data == null){
                  return Container();
                }else if(snapshot.connectionState == ConnectionState.done){
                  File coverImage = snapshot.data![1];
                File pfpImage = snapshot.data![0];
                bool isThereCover = coverImage.existsSync();
      bool isThere = pfpImage.existsSync();
                print("===================isther cover ===========$isThereCover");
                return ListView(
                  children: [
                    Container(
                      height: 280,
                      child: Stack(
                        children: [
                       Container(
                            
                        child: Stack(
                          children: [
                            cover(isThereCover,coverImage),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                _pickImageCover(ImageSource.gallery,(){setState(() {
                                  
                                });});
                                setState((){});
                               },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.indigo.withOpacity(.5)
                                ),child: Icon(Icons.edit,color: Colors.white,),),
                              ),
                            )
                          ],
                        )),
                        
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Stack(alignment: Alignment.bottomCenter,
                                        children: [
                                          Container(
                                            height: 90,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Container(
                                            
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 5,
                                                color:frame != ""? Colors.transparent :Colors.black,),
                                              shape: BoxShape.circle
                                            ),
                                            
                                              child: CircleAvatar(
                                                
                                                        radius: 65,
                                                        backgroundImage: isThere
                                                            ? FileImage(pfpImage)
                                                            : AssetImage('assets/images/giphy.gif') as ImageProvider,
                                                             ),
                                            ),
                                          ),
                                           //? the Rank budget 
                                           if(frame != "")
                                        Image.asset(frame,width: 165, height:150,fit: BoxFit.cover, ),
                                            
                                        ],
                                      ),
                        ),
                      ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:4),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            button("Change avatar", () {
                              _pickImageCover1(ImageSource.gallery,(){setState(() {
                                
                              });});
                              setState((){});
                             }),
                        button("Change Frame", () {
                          bottomSheet((){setState(() {
                            
                          });});
                         }),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text("UserName",
                        style: TextStyle(
                          fontFamily: "Quick",
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).iconTheme.color!.withOpacity(.6),
                          fontSize: 16
                        ),),
                        Padding(
                          padding: const EdgeInsets.only(top:8),
                          child: Container(
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: .5,
                                color:Theme.of(context).iconTheme.color!.withOpacity(.2))
                            ),
                            child: TextField(
                              onChanged: (controller){
                                
                              },
                              controller: controller,
                              maxLength: 10,
                              decoration: InputDecoration(
                                counter: 
                                  Offstage(),
                                  suffix: Padding(
                                    padding: const EdgeInsets.only(right:8.0),
                                    child: Text("/10",
                                    style: TextStyle(
                                      fontSize: 14,
                                    color: Theme.of(context).iconTheme.color!.withOpacity(.4),),),
                                  ),
                                contentPadding: EdgeInsets.only(left:12),
                                
                                border:InputBorder.none 
                              ),
                            ),
                          ),
                        )
                      ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 8),
                      child: Text("Your UserName is showing in the main quests page you can change it when ever you want from here though it must stay in the 10 letters limit ",
                      style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,color: Theme.of(context).iconTheme.color!.withOpacity(.5)),),
                    ),
                    SizedBox(height: 100,),
                    Align(alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: (){
                          user.userName = controller.text;
                          ProfileProvider().saveProfile(user, "",context);
                          Navigator.popAndPushNamed(context, "HomePage");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 100,vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.indigo
                          ),
                          child: Text("Save",
                          style: TextStyle(
                            fontFamily: "Quick",
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),)),
                      ))
                  ],);
                }else{
                  return Container();
                }
              }
            );
          }
        ),
      ),
    );
  }
  Widget button(String title,void Function() onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.indigo.withOpacity(.3),
        ),
        child: Text(title,
        style: TextStyle(
          fontFamily: "Quick",
          //color: Colors.indigo,
          fontSize: 16,
          fontWeight: FontWeight.bold,),),
      ),
    );
  }

  void bottomSheet(void Function() refresh){
    // Filter the archive map based on inventory keys and item type "frame"
/*List<dynamic> frameItemsInInventory = archive.entries
    .where((entry) => user.inventory.contains(entry.key) && entry.value.itemType == "frame")
    .map((entry) => entry.value)
    .toList();*/
    List<dynamic> ids = user.inventory.where((element) => element.contains("Frame")).toList();
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext context){
        if(ids.isEmpty){
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              child: Text(
                textAlign: TextAlign.center,
                "The Frames you own will appears here currently you have none (0o0!)",
              style: TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                fontSize: 22
              ),),),
          );
        }else{
        return Container(
          padding: EdgeInsets.all(8),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: ids.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3),
            itemBuilder: (context, index) {
              String pathFrame = user.framePath;
              // get the item and its count at the current index
              String itemId = ids[index];
          
              // find the corresponding item in the archive
              ShopItem item = archive[itemId];
          
              // build the widget for the item
              return Padding(
                padding: const EdgeInsets.all(4),
                child: 
                itemData(item.title, item.image, () {
            user.framePath = item.image;
            ProfileProvider().saveProfile(user, "",context);
            refresh;
            Navigator.pop(context);
                },item.rarity,item.image,pathFrame),
              );
            },
          ),
        );
        }
      });
  }

  Widget itemData(String name, String image, void Function() onTap,int rarity,String path,String pathFrame){
    return GestureDetector(
      onTap:
          onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color:Colors.indigo),
              color: Theme.of(context).cardColor,
              boxShadow:[BoxShadow(
                color: Theme.of(context).shadowColor, // Shadow color
                spreadRadius: 1, // Extends the shadow beyond the box
                blurRadius: 5, // Blurs the edges of the shadow
                offset: const Offset(0, 3), // Moves the shadow slightly down and right
                )]
            ),
            child: Stack(alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(image),
                ),
                //Divider(),
                if(pathFrame == path)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.indigo
                ),child: Icon(Icons.done,color: Colors.white,),)
              ],
            )),
            
        ],
      ),
    );
  }
}



/*
import 'dart:io';

import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({Key? key}) : super(key: key);

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  late File pfpPath;
  late File coverPath;
  bool isThereCover = false;
  bool isThere = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _loadImage();
    _loadCover();
  }

  Future<void> _loadImage() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDirectory.path}/pfp_image.png';
    setState(() {
      pfpPath = File(filePath);
      isThere = pfpPath.existsSync();
    });
  }

  Future<void> _loadCover() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDirectory.path}/cover_image.png';
    setState(() {
      coverPath = File(filePath);
      isThereCover = coverPath.existsSync();
    });
  }

  Future<void> _pickImageCover(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String filePath = '${appDirectory.path}/cover_image.png';

      await imageFile.copy(filePath);

      setState(() {
        coverPath = File(filePath);
        isThereCover = true; // Update state to indicate that the image is present
      });
    }
  }

  Future<void> _pickImageCover1(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String filePath = '${appDirectory.path}/pfp_image.png';

      await imageFile.copy(filePath);

      setState(() {
        pfpPath = File(filePath);
        isThere = true; // Update state to indicate that the image is present
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Profile user = ProfileProvider().readProfile();
    String frame = user.framePath;
    controller.text = user.userName;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.popAndPushNamed(context, "HomePage");
          },
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const Text(
          "Profile Information",
          style: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.bold),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          } else {
            Navigator.popAndPushNamed(context, "HomePage");
          }
        },
        child: StatefulBuilder(
          builder: (context, setState) {
            return ListView(
              children: [
                Container(
                  height: 280,
                  child: Stack(
                    children: [
                      Container(
                        child: Stack(
                          children: [
                            _coverWidget(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  _pickImageCover(ImageSource.gallery);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.indigo.withOpacity(.5),
                                  ),
                                  child: const Icon(Icons.edit, color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 5,
                                    color: frame != "" ? Colors.transparent : Colors.black,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 65,
                                  backgroundImage: isThere
                                      ? FileImage(pfpPath)
                                      : const AssetImage('assets/images/giphy.gif') as ImageProvider,
                                ),
                              ),
                            ),
                            //? the Rank budget
                            if (frame != "") Image.asset(frame, width: 165, height: 150, fit: BoxFit.cover),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _button("Change avatar", () {
                          _pickImageCover1(ImageSource.gallery);
                        }),
                        _button("Change Frame", () {
                          bottomSheet(() {
                            setState(() {});
                          });
                        }),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "UserName",
                        style: TextStyle(
                          fontFamily: "Quick",
                          fontWeight: FontWeight.bold,
                          //color: Theme.of(context).iconTheme.color!.withOpacity(.6),
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: .5,
                              //color:Theme.of(context).iconTheme.color!.withOpacity(.2)
                            ),
                          ),
                          child: TextField(
                            onChanged: (controller) {},
                            controller: controller,
                            maxLength: 10,
                            decoration: const InputDecoration(
                              counter: Offstage(),
                              suffix: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "/10",
                                  style: TextStyle(
                                    fontSize: 14,
                                    //color: Theme.of(context).iconTheme.color!.withOpacity(.4),
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(left: 12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Text(
                    "Your UserName is showing in the main quests page you can change it when ever you want from here though it must stay in the 10 letters limit ",
                    style: TextStyle(
                      fontFamily: "Quick",
                      fontWeight: FontWeight.bold,
                      //color: Theme.of(context).iconTheme.color!.withOpacity(.5)
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      //user.userName = controller.text;
                      //ProfileProvider().saveProfile(user, "",context);
                      Navigator.popAndPushNamed(context, "HomePage");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.indigo,
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontFamily: "Quick",
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _coverWidget() {
    if (isThereCover) {
      return Container(
        height: 220,
        width: MediaQuery.of(context).size.width,
        child: Image.file(coverPath, fit: BoxFit.cover),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        height: 220,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'assets/images/giphy.gif',
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget _button(String title, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.indigo.withOpacity(.3),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: "Quick",
            //color: Colors.indigo,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void bottomSheet(void Function() refresh) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "The Frames you own will appear here currently you have none (0o0!)",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          );
        });
  }
}
*/