import 'dart:async';
import 'package:SoloLife/app/core/values/amount.dart';
import 'package:SoloLife/app/data/models/achievements.dart';
import 'package:SoloLife/app/data/models/budget.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';

class BudgetManager extends StatefulWidget {
  const BudgetManager({super.key});

  @override
  State<BudgetManager> createState() => _BudgetManagerState();
}

class _BudgetManagerState extends State<BudgetManager> {

  // Initializing variables and controller
  TextEditingController controller = TextEditingController();
  TextEditingController recordController = TextEditingController();
  List<deposit> log = Amount().readBudget();
  bool revenues = true;
  int isHidden = 999999999999;
  bool isVisible = false;
  bool editing = false;

  @override
  Widget build(BuildContext context) {
    // Initializing variables
    bool lastState = log.length == 0 ? true : log.last.add;
    int total = Amount().totalGater(log);
    // the ui
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "HomePage");
            },
            icon: Icon(Icons.arrow_back)),
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Budget manager"),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          Navigator.popAndPushNamed(context, "HomePage");
        },
        child: ListView.builder(
            shrinkWrap: true,
            reverse: true,
            itemCount: log.length + 1,
            itemBuilder: (context, int index) {
              int itemIndex = index;
              if (index != log.length) {
                bool state = log[itemIndex].add;
                String amount = formatNumber(log[itemIndex].amount);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Dismissible(
                    onDismissed: (_) {
                      total -= log[itemIndex].amount;
                      log.removeAt(itemIndex);
                      Amount().writeBudget(log);
                      setState(() {});
                    },
                    key: ValueKey(log[itemIndex].amount),
                    background: Container(
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        isVisible = false;
                        isHidden = isHidden != index ? index : log.length + 1;
                        setState(() {});
                        Future.delayed(Duration(milliseconds: 400)).then((_) {
                          isVisible = !isVisible;
                          setState(() {});
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: isHidden == index ? 200 : 90,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Colors.grey.withOpacity(.2)),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(.7), // Shadow color
                                spreadRadius:
                                    2, // Extends the shadow beyond the box
                                blurRadius: 5, // Blurs the edges of the shadow
                                offset: const Offset(0,
                                    3), // Moves the shadow slightly down and right
                              )
                            ]),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                log[itemIndex].dateTime,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Quick"),
                              ),
                              leading: Text(
                                '${state ? '+' : '-'}${amount}',
                                style: TextStyle(
                                    color: state ? Colors.green : Colors.red,
                                    fontFamily: "Quick",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                state ? "Deposit" : "Withdraw",
                                style: TextStyle(
                                    fontFamily: "Quick",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: state ? Colors.green : Colors.red),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 60),
                              child: Divider(
                                color: Theme.of(context)
                                    .iconTheme
                                    .color!
                                    .withOpacity(.4),
                              ),
                            ),
                            if (isVisible && isHidden == index)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (!editing)
                                      Expanded(
                                        child: Text(
                                          log[itemIndex].record.isNotEmpty
                                              ? log[itemIndex].record
                                              : "No Record For That Entry",
                                          softWrap: true,
                                          maxLines: 3,
                                          style: TextStyle(
                                              fontFamily: 'Quick',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    if (editing)
                                      Expanded(
                                          child: TextField(
                                        maxLines: 3,
                                        controller: recordController,
                                      )),
                                    GestureDetector(
                                      onTap: () {
                                        editing = !editing;
                                        if (editing) {
                                          recordController.text =
                                              log[index].record;
                                        }
                                        log[index].record =
                                            recordController.text;
                                        Amount().writeBudget(log);
                                        if (!editing) {
                                          recordController.clear();
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Text(
                                            "Add",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontFamily: 'Quick',
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor, // Shadow color
                          spreadRadius: 2, // Extends the shadow beyond the box
                          blurRadius: 5, // Blurs the edges of the shadow
                          offset: const Offset(
                              0, 3), // Moves the shadow slightly down and right
                        )
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: total < 0 ? Colors.red : Colors.green,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "total : $total ",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Quick",
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: revenues ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(15)),
                            child: GestureDetector(
                                onTap: () {
                                  revenues = !revenues;
                                  setState(() {});
                                },
                                child: Text(
                                  revenues ? "Deposit" : "Withdraw",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Quick",
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text.rich(TextSpan(
                            children: [
                              TextSpan(
                                text: "Last Action Record :",
                              ),
                              TextSpan(
                                text: lastState ? "Deposit  " : "Withdraw ",
                                style: TextStyle(
                                    color:
                                        lastState ? Colors.green : Colors.red),
                              ),
                              TextSpan(
                                  text: "${log.isEmpty ? 0 : log.last.amount}",
                                  style: TextStyle(
                                      color: lastState
                                          ? Colors.green
                                          : Colors.red)),
                            ],
                            style: TextStyle(
                              fontFamily: "Quick",
                              fontWeight: FontWeight.bold,
                            ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                cursorColor: Theme.of(context).iconTheme.color,
                                decoration: InputDecoration(
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.purple,
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                            onPressed: () {
                                              int amount =
                                                  double.parse(controller.text)
                                                      .toInt();
                                              List<deposit> budget =
                                                  Amount().readBudget();
                                              deposit newBudget = deposit(
                                                  dateTime: formatDateTime(
                                                      DateTime.now(), true),
                                                  amount: amount,
                                                  add: revenues);
                                              budget.add(newBudget);
                                              log.add(newBudget);
                                              Amount()
                                                  .writeBudget(budget);
                                                  setState(() {
                                                    
                                                  });
                                              achievementsHandler("budget",context);
                                              if(controller.text.contains(".")){
                                                achievementsHandler("extra",context);
                                              }
                                              if(controller.text.contains("00000")){
                                                achievementsHandler("extra2",context);
                                              }
                                              controller.clear();
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.add,
                                                color: Colors.white))),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          width: .5,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color!
                                              .withOpacity(.4))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        width: .5,
                                        color: Theme.of(context)
                                            .iconTheme
                                            .color!
                                            .withOpacity(.4),
                                      )),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: false),
                                controller: controller,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}

String dateOfAdding(DateTime date) {
  return "${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}";
}
