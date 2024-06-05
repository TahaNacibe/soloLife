import 'dart:async';
import 'dart:math';

import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:animated_glitch/animated_glitch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String result = "";
  int current = 0;
  bool blink = true;
  Profile user = ProfileProvider().readProfile();
  @override
  void initState() {
    screenMessage();
    blinkSystem();
    super.initState();
  }

  Future<void> blinkSystem() async {
    Timer.periodic(Duration(milliseconds: 500), (_) {
      blink = !blink;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGlitch(
        controller: AnimatedGlitchController(
            chance: 100, frequency: Duration(milliseconds: 10)),
        child: Container(
          padding: EdgeInsets.all(18),
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: Colors.black,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: result,
                      ),
                      if (blink) TextSpan(text: "|")
                    ]),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Quick",
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    points(current, 0),
                    points(current, 1),
                    points(current, 2),
                    points(current, 3),
                    if (current == 4)
                      Icon(
                        Icons.question_mark,
                        color: Colors.white,
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget points(int current, int privet) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (current >= privet ? Colors.indigo : Colors.grey)
                .withOpacity(.5),
            boxShadow: [
              BoxShadow(
                  color: (current >= privet ? Colors.indigo : Colors.white)
                      .withOpacity(.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 3))
            ]),
      ),
    );
  }

  Future<void> screenMessage() async {
    List<String> items = [
      "You Have Been Selected By The System to Become Player.",
      "Complete Tasks and use mods to achieve higher Levels.",
      "Unlock Achievements as Witnesses of your Journey.",
      "May Fortune be with you Player.",
    ];
    for (String item in items) {
      for (var i = 0; i < item.length; i++) {
        if (item[i] != ".") {
          result = result + item[i];
        } else {
          await Future.delayed(Duration(seconds: 1));
          result = "";
          current = current + 1;
        }
        setState(() {});
        await Future.delayed(Duration(milliseconds: 150));
      }
    }
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
    for (String char in "Good Luck ■■■■".characters) {
      result = result + char;
      setState(() {});
      await Future.delayed(Duration(microseconds: 150));
    }
    await Future.delayed(Duration(seconds: 1));
    user.haveMessage = false;
    ProfileProvider().saveProfile(user, "", context);
     SystemNavigator.pop();
  }
}


