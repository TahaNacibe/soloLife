import 'package:SoloLife/app/core/utils/start_messages.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:math' as math;

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key); // Corrected the constructor

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

// get a random index for the start message
int index() {
  int max = start.length;
  final random = math.Random();
  int result = 0;
  // get the xp
  result = random.nextInt(max - 0); // + 1 for inclusive max
  return result;
}

class _LoadingPageState extends State<LoadingPage> {
  Profile user = ProfileProvider().readProfile();
  @override
  void initState() {
    super.initState();
    outputMessage();
    missing().strikeManager(context);
    action();
  }

  void action() {
    Future.delayed(Duration(seconds: 2), () {
      // Added a callback function
      Navigator.popAndPushNamed(context, "HomePage");
    });
  }

  int indexValue = index();
  List<String> output = [
    ">> Reading Player Data...\n",
    ">> Importing Player Information...\n",
    ">> Accessing The System...\n",
    ">> Open System \n"
  ];

  String result = ">> Starting...\n";

// the animation of the text
  void outputMessage() {
    for (int i = 0; i < output.length; i++) {
      Future.delayed(Duration(milliseconds: (i + 1) * 500), () {
        setState(() {
          result += output[i];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height,
          color: Theme.of(context).cardColor,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.sizeOf(context).height / 2),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sol",
                                style: TextStyle(
                                    fontFamily: "Quick",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 50),
                              ),
                              Container(
                                  width: 40,
                                  height: 40,
                                  child: Image(
                                      image: AssetImage(
                                          "assets/images/icon.png"))),
                            ],
                          ),
                          Text(
                            "    Life",
                            style: TextStyle(
                                fontFamily: "Quick",
                                fontWeight: FontWeight.w600,
                                fontSize: 50,
                                color: const Color.fromARGB(255, 47, 33, 243)),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          padding: EdgeInsets.all(4),
                          color: Colors.blueGrey.withOpacity(.1),
                          child: Text(
                            result,
                            style: TextStyle(
                                fontFamily: "Quick",
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: 12),
                          )),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: Divider(),
                          ),
                          Container(
                            color: Theme.of(context).cardColor,
                            padding: EdgeInsets.only(left: 8, right: 8, top: 4),
                            child: Center(
                              child: LoadingAnimationWidget.inkDrop(
                                color: Theme.of(context).iconTheme.color!,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: start[indexValue],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
