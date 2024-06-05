import 'package:SoloLife/app/data/models/achievements.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/models/volt.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/voiceCommand/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class VoltageView extends StatefulWidget {
  const VoltageView({super.key});

  @override
  State<VoltageView> createState() => _VoltageViewState();
}

class _VoltageViewState extends State<VoltageView> {
  // Initializing variables
  TextEditingController entryController = TextEditingController();
  bool isPositive = true;
  bool isShowing = false;

  @override
  Widget build(BuildContext context) {
    // Initializing variables and getting the data into the lists
    List<Volt> yourVoltage = VoltageProvider().readVolt();
    List<Volt> Positive = yourVoltage.where((volt) => volt.isPositive).toList();
    List<Volt> Negative =
        yourVoltage.where((volt) => !volt.isPositive).toList();
    int voltageLevel = userInfo.voltage;
    int total = yourVoltage.length;

    // check the achievements 
    void action() {
      // check the achievements before sending the type to the handler
      if (Positive.length >= 100) {
        yourVoltage = [];
        VoltageProvider().writeVolt(yourVoltage);
        UserState state = StatesProvider().readState();
        state.points += 10;
        userInfo.voltage += 1;
        ProfileProvider().saveProfile(userInfo, "", context);
        StatesProvider().writeState(state);

        // check the achievements before sending the type to the handler
        if(Negative.length == 99 && !userInfo.achievements.contains("lastGood")){
        achievementsHandler("99good", context);
        }
        // check the achievements before sending the type to the handler
        if(Negative.length == 0 && !userInfo.achievements.contains("sentence")){
          achievementsHandler("sentence", context);
        }
        // check the achievements before sending the type to the handler
      } else if (Negative.length >= 100) {
        yourVoltage = [];
        VoltageProvider().writeVolt(yourVoltage);
        userInfo.voltage -= 1;
        ProfileProvider().saveProfile(userInfo, "", context);
        if(Positive.length == 99 && !userInfo.achievements.contains("lastBad")){
        achievementsHandler("99bad", context);
        }
      }
    }

    return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                voltMeter(total, Positive.length, "Positive Volt", Colors.blue),
                voltMeter(total, Negative.length, "Negative Volt", Colors.red)
              ],
            ),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CircularStepProgressIndicator(
                    totalSteps: 100,
                    currentStep: Positive.length,
                    stepSize: 10,
                    selectedColor: Colors.teal,
                    unselectedColor: Theme.of(context).cardColor,
                    padding: 0,
                    width: 200,
                    height: 200,
                    selectedStepSize: 15,
                    roundedCap: (_, __) => true,
                    child: GestureDetector(
                      onTap: () {
                        isShowing = !isShowing;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: isShowing
                                ? Colors.white
                                : Theme.of(context).cardColor.withOpacity(.5),
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle),
                        child: isShowing
                            ? Center(
                                child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        //color:Colors.white,
                                        shape: BoxShape.circle),
                                    child: Text(
                                      "${Positive.length}%",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontFamily: "Quick",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 45),
                                    )))
                            : CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    AssetImage('assets/images/thunder.gif')
                                        as ImageProvider,
                              ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.teal.withOpacity(.8), // Shadow color
                              spreadRadius:
                                  2, // Extends the shadow beyond the box
                              blurRadius: 5, // Blurs the edges of the shadow
                              offset: const Offset(0,
                                  3), // Moves the shadow slightly down and right
                            )
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.teal),
                      child: Text(
                        "Voltage: $voltageLevel",
                        style: TextStyle(
                            fontFamily: "Quick", fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
            // the second part
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor, // Shadow color
                          spreadRadius: 2, // Extends the shadow beyond the box
                          blurRadius: 5, // Blurs the edges of the shadow
                          offset: const Offset(
                              0, 3), // Moves the shadow slightly down and right
                        )
                      ],
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: TextFormField(
                            cursorColor: Theme.of(context).iconTheme.color,
                            controller: entryController,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 20, left: 14),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    isPositive = !isPositive;
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: isPositive
                                                  ? Colors.green
                                                  : Colors.red,
                                              width: 2)),
                                      child: Text(
                                        isPositive ? "Positive" : "Negative",
                                        style: TextStyle(
                                            color: isPositive
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    String title = entryController.text;
                                    if (title.isNotEmpty) {
                                      Volt entry = Volt(
                                          title: title, isPositive: isPositive);
                                      if (yourVoltage.contains(entry)) {
                                        EasyLoading.showError("already there");
                                      } else {
                                        yourVoltage.add(entry);
                                        VoltageProvider()
                                            .writeVolt(yourVoltage);
                                        achievementsHandler("voltage", context);
                                        if(Positive.length == Negative.length && Positive.length == 50){
                                          achievementsHandler("balance", context);
                                        }
                                        entryController.clear();
                                        action();
                                        setState(() {});
                                      }
                                    } else {
                                      EasyLoading.showError("Can't be empty");
                                    }
                                  },
                                  icon: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                          color: Colors.purple,
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.done,
                                          color: Colors.white)),
                                )),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter the quest title';
                              }
                              return null;
                            },
                          ),
                        ),
                        Divider(
                          color: Theme.of(context)
                              .iconTheme
                              .color!
                              .withOpacity(.4),
                        ),
                        ListView.builder(
                            itemCount: total + 1,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (index == total) {
                                return Container(
                                  height: 50,
                                );
                              } else {
                                return Dismissible(
                                  key: ValueKey(yourVoltage[index]),
                                  onDismissed: (_) {
                                    yourVoltage.remove(yourVoltage[index]);
                                    VoltageProvider().writeVolt(yourVoltage);
                                    setState(() {});
                                  },
                                  background: Container(
                                    color: Colors.red.withOpacity(0.8),
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    yourVoltage[index].title,
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: "Quick",
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4),
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                            color: yourVoltage[
                                                                        index]
                                                                    .isPositive
                                                                ? Colors.green
                                                                : Colors.red,
                                                            width: 2)),
                                                    child: Text(
                                                        style: TextStyle(
                                                            fontFamily: "Quick",
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: yourVoltage[
                                                                        index]
                                                                    .isPositive
                                                                ? Colors.green
                                                                : Colors.red),
                                                        yourVoltage[index]
                                                                .isPositive
                                                            ? " Positive"
                                                            : " Negative"),
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: Divider(),
                                      )
                                    ],
                                  ),
                                );
                              }
                            })
                      ],
                    ),
                  )),
            )
          ],
        ));
  }
}

// the volt meter is : the progress circulars 
Widget voltMeter(int total, int current, String title, Color color) {
  return Column(
    children: [
      CircularStepProgressIndicator(
        selectedColor: color,
        totalSteps: total == 0 ? 10 : total,
        currentStep: current,
        width: 100,
        roundedCap: (_, isSelected) => isSelected,
        child: Align(
            alignment: Alignment.center,
            child: Text(
              // the total steps
              "$current/$total",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Quick",
                  fontWeight: FontWeight.bold),
            )),
      ),
      // title
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 22, fontFamily: "Quick", fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}
