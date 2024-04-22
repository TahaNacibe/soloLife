import 'package:SoloLife/app/core/utils/start_messages.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:math' as math;

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key); // Corrected the constructor

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  
  @override
  void initState() {
    super.initState();
    action();
  }

  void action() {
    Future.delayed(Duration(seconds: 2), () {  // Added a callback function
      Navigator.popAndPushNamed(context, "HomePage");
    });
  }
 int index(){
  int max = start.length;
  final random = math.Random();
  int result = 0;
  // get the xp
    result = random.nextInt(max - 0); // + 1 for inclusive max
  return result;
 }


  @override
  Widget build(BuildContext context) {
    return  Container(
        color: Theme.of(context).cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          //? LOading Message
          Padding(
            padding: const EdgeInsets.all(12),
            child: start[index()],
          ),
            Padding(
              padding: const EdgeInsets.only(top:20),
              child: Column(
                children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                             "Sol",
                             style: TextStyle(
                          fontFamily: "Quick",
                          fontWeight: FontWeight.bold,
                          fontSize: 60
                          ),
                          ),
                          Container(width: 50,height: 50,
                child: Image(image:AssetImage("assets/images/icon.png"))),
                        ],
                      ),
                      Text(
                         "    Life",
                        style: TextStyle(
                          fontFamily: "Quick",
                          fontWeight: FontWeight.bold,
                          fontSize: 60,
                          color: const Color.fromARGB(255, 47, 33, 243)),
                      ),
              
                   
                ],
              ),
            ),
            
            SizedBox(height: 100,),
            Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).iconTheme.color!,
                size: 70,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(" Dream Seeker ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Quick"),
              ),
            ),
            
           SizedBox(height: 100,
           )
          ],
        
      ),
    );
  }
}
