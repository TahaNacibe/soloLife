import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  File? _coverImage;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load saved images if available
    _loadImages();
  }

  Future<void> _loadImages() async {
  final directory = await getApplicationDocumentsDirectory();
  final profileImagePath = '${directory.path}/pfp_image.png';
  final coverImagePath = '${directory.path}/cover_image.png';

  setState(() {
    if (File(profileImagePath).existsSync()) {
      _profileImage = File(profileImagePath);
    }

    if (File(coverImagePath).existsSync()) {
      _coverImage = File(coverImagePath);
    }
  });
}


  Future<void> _saveImage(String key, File? image) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$key.png';
  
  if (image != null) {
    await image.copy(filePath);
  } else {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}


  Future getImage(ImageSource source, bool isProfile) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        if (isProfile) {
          _profileImage = File(pickedFile.path);
          _saveImage('pfp_image', _profileImage);
          print("======================here yes");
          Provider.of<ImageData>(context, listen: false).updateProfileImage(File(pickedFile.path));
          print("=======================here yes 2");
        } else {
          _coverImage = File(pickedFile.path);
          _saveImage('cover_image', _coverImage);
          Provider.of<ImageData>(context, listen: false).updateCoverImage(File(pickedFile.path));
        }
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: PopScope(canPop: false,
        onPopInvoked: (didPop) async {
  if (didPop) {
    return;
  }else{
    Navigator.popAndPushNamed(context, "HomePage");
  }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () => getImage(ImageSource.gallery, true),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : AssetImage('assets/images/giphy.gif') as ImageProvider,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  getImage(ImageSource.gallery, true);
                },
                child: Text('Change Profile Image'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: InkWell(
                  onTap: () => getImage(ImageSource.gallery, false),
                  child: Container(
                    decoration: BoxDecoration(
                      image: _coverImage != null
                          ? DecorationImage(
                              image: FileImage(_coverImage!),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: AssetImage('assets/images/giphy.gif'),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            getImage(ImageSource.gallery, false);
                          },
                          child: Text('Change Cover Image'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageData extends ChangeNotifier {
  File? _profileImage;
  File? _coverImage;

  File? get profileImage => _profileImage;
  File? get coverImage => _coverImage;

  void updateProfileImage(File? newImage) {
    _profileImage = newImage;
    notifyListeners();
  }

  void updateCoverImage(File? newImage) {
    _coverImage = newImage;
    notifyListeners();
  }
}