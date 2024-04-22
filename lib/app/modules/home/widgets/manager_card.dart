import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/data/models/budget.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerCard extends StatefulWidget {
  final homeCtrl = Get.find<HomeController>();
  ManagerCard({super.key});

  @override
  State<ManagerCard> createState() => _ManagerCardState();
}

class _ManagerCardState extends State<ManagerCard> {
  @override
  Widget build(BuildContext context) {
    var squareWidth = Get.width - 12.0.wp;
    List<Budget> log = BudgetProvider().readBudget();
    int total = BudgetProvider().totalGater(log);
    return GestureDetector(
      onTap:(){
        Navigator.popAndPushNamed(
                    context,
                    "manager"
                  );
      },
      child: Container(
        width: squareWidth / 2,
        height: squareWidth /2,
        margin: EdgeInsets.all(2.0.wp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor, boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            spreadRadius: -2,
            offset: const Offset(0, 7),
          )
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(6.0.wp,6.0.wp,6.0.wp,7.0.wp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Budget Manager",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontFamily: "Quick",
                        fontSize: 12.0.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1.5.wp,
                  ),
                  Text(
                    'Credit : $total DA',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
            Align(alignment: Alignment.bottomRight,
              child: Container(
                decoration:const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))
                ),
                
                child: Padding(
                padding: EdgeInsets.all(6.5.wp),
                child: const Icon(Icons.money,
                  color: Colors.white,
                ),
                            ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
