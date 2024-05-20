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
  String globalFrame = "";
  bool isThere = false;
  // ---------------
  late File coverPath;
  bool isThereCover = false;
  // -------------------
  String frame = user.framePath;
  // -------------
  int length = 0;
  // --------------
  
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
      setState(() {
        coverPath = File(filePath);
        isThereCover = true;
      });
    }else{
      setState(() {
        coverPath = File("");
        isThereCover = false;
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
        isThere = true;
    }
    if(await pfpPath.exists()){
      isThereCover = true;
    }
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
Future<void> deleteCoverDirectory(String path) async {
  String coverDirectoryPath = path;
  print("============================== action is taking ===============${await Directory(coverDirectoryPath).exists()}");
  // Check if the directory exists
  if (await Directory(coverDirectoryPath).exists()) {
    // Delete the directory and all its contents recursively
    Directory(coverDirectoryPath).deleteSync(recursive: true);
    print('Cover directory deleted successfully.');
  } else {
    print('${coverDirectoryPath} does not exist.');
  }
}
Future<void> _pickImageCover(ImageSource source,VoidCallback refresh) async {
  final pickedFile = await ImagePicker().pickImage(source: source);

  if (pickedFile != null) {
    final File imageFile = File(pickedFile.path);
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    deleteCoverDirectory(user.coverPath);
    print("======================== action1");
    final String filePath = '${appDirectory.path}/${DateTime.now()}.jpg';
    print("======================== action2");
    await imageFile.copy(filePath);
    user.coverPath = filePath;
    ProfileProvider().saveProfile(user, "", context);
    print("======================== action3");
    print("======================== ${user.coverPath}");
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
    final String filePath = '${appDirectory.path}/${DateTime.now()}.jpg';
    deleteCoverDirectory(user.pfpPath);
    user.pfpPath = filePath;
    await imageFile.copy(filePath);
    ProfileProvider().saveProfile(user, "", context);
      pfpPath = File(filePath);
      isThere = true; // Update state to indicate that the image is present
    setState(() {
    });
        refresh;

  }
    refresh;
}

void getImages() {
      Profile user = ProfileProvider().readProfile();
      globalFrame = user.framePath;
    if(user.coverPath != ""){
      setState(() {
        coverPath = File(user.coverPath);
        isThereCover = true;
      });
    }else{
        setState(() {
        coverPath = File("");
        isThereCover = false;
      });
    }
    if(user.pfpPath != ""){
      setState(() {
        print("================${user.pfpPath}");
        pfpPath = File(user.pfpPath);
        isThere = true;
      });
    }else{
        setState(() {
        pfpPath = File("");
        isThere = false;
      });
    }
    }
  @override
  void initState() {
    //_loadImage();
    controller.text = user.userName;
    length = user.userName.characters.length;
    getImages();
    super.initState();
  }
  TextEditingController controller = TextEditingController();
  Widget build(BuildContext context,) {
    
    Widget cover(bool isThereCover,File path){
      if(user.coverPath != "") {

            
            return Container(
              height: 250,
              width: MediaQuery.sizeOf(context).width,
              child: Image.file(path,fit: BoxFit.cover,));

      }else{
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))
          ),
          height: 250,
          width: MediaQuery.sizeOf(context).width,
          child: Image.asset(
            'assets/images/giphy.gif',
            fit: BoxFit.cover,
            ));
      }
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))
        ),
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
  }
  Navigator.popAndPushNamed(context, "HomePage");
  },
        child: ListView(
                  children: [
                    Container(
                      height: 270,
                      child: Stack(
                        children: [
                       Container(
                            
                        child: Stack(
                          children: [
                            cover(isThereCover,coverPath),
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
                                                color:globalFrame != ""? Colors.transparent :Colors.black,),
                                              shape: BoxShape.circle
                                            ),
                                            
                                              child: CircleAvatar(
                                                
                                                        radius: 65,
                                                        backgroundImage: isThere
                                                            ? FileImage(pfpPath)
                                                            : AssetImage('assets/images/giphy.gif') as ImageProvider,
                                                             ),
                                            ),
                                          ),
                                           //? the Rank budget 
                                           if(globalFrame != "")
                                        Image.asset(globalFrame,width: 165, height:150,fit: BoxFit.cover, ),
                                            
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
                            //Container(),
                        button("Change Frame", () {
                          bottomSheet(
                            (){
                            user.framePath = globalFrame;
                            ProfileProvider().saveProfile(user, "", context);
                              setState(() {
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
                                length = controller.characters.length;
                                setState((){});
                              },
                              controller: controller,
                              maxLength: 15,
                              decoration: InputDecoration(
                                counter: 
                                  Offstage(),
                                  suffix: Padding(
                                    padding: const EdgeInsets.only(right:8.0),
                                    child: Text("$length/15",
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
                    Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: Align(alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: (){
                            user.userName = controller.text;
                            user.framePath = globalFrame;
                            ProfileProvider().saveProfile(user, "",context);
                            Navigator.popAndPushNamed(context, "HomePage");
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 80,vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.indigo
                            ),
                            child: Text("Change Name",
                            style: TextStyle(
                              fontFamily: "Quick",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),)),
                        )),
                    )
                  ],),
      )
    );
  }
  Widget button(String title,void Function() onTap){
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 22,vertical: 12),
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
        ],
      ),
    );
  }

  void bottomSheet(void Function() refresh){
    // Filter the archive map based on inventory keys and item type "frame"
/*List<dynamic> frameItemsInInventory = archive.entries
    .where((entry) => user.inventory.contains(entry.key) && entry.value.itemType == "frame")
    .map((entry) => entry.value)
    .toList();*/
    List<dynamic> ids = user.inventory.where((element) => (element.contains("Frame") && archive[element] != null)).toList();
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      elevation: 10,
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
        return StatefulBuilder(
          builder: (context,setState) {
            return Container(
              padding: EdgeInsets.all(12),
              child: SingleChildScrollView(
        
                child: Column(
                  children: [
                    Text("Choose a New Frame",style: TextStyle(
                  fontFamily: "Quick",
                  fontWeight: FontWeight.bold,
                  fontSize: 21)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 8),
                    child: Divider(),
                  ),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ids.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1,
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
                          GestureDetector(
                            onTap:() {
                              //Profile user = ProfileProvider().readProfile();
                                        globalFrame = item.image;
                                        
                                        
                                        //print("---------- cover ----------------${user.framePath}");
                                        //ProfileProvider().saveProfile(user, "",context);
                                        //Profile user1 = ProfileProvider().readProfile();
                                        print("--- -------- --------- -------- 2 ---- ${globalFrame}");
                                        setState((){});
                                        refresh();
                                        //Navigator.pop(context);
                            },
                            child: Stack(
                              children: [
                                itemData(item.title, item.image,item.rarity,item.image,pathFrame),
                              if(item.image == globalFrame)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.indigo.withOpacity(.85)
                    ),child: Icon(Icons.done,color: Colors.white,),)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        );
        }
      });
  }

  Widget itemData(String name, String image,int rarity,String path,String pathFrame){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color:Colors.indigo.withOpacity(.3)),
        color: Colors.indigo.withOpacity(.15),
        
      ),
      child: Stack(alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Image.asset(image),
          ),
          //Divider(),
          
        ],
      ));
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