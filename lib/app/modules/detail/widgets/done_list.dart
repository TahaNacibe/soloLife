import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoneList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoneList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeCtrl.doneTodos.isNotEmpty
        ? ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Align(alignment: Alignment.topCenter,
                  child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.0.wp,
                    horizontal: 5.0.wp,
                  ),
                  child: Stack(alignment: Alignment.centerLeft,
                        children: [
                              Divider(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).cardColor,
                          ),
                            child: Text('Finished Tasks',
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontFamily: "Quick",
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                                ),
                ),
              ...homeCtrl.doneTodos
                  .map((element) => Padding(
                                key: ObjectKey(element),
                              padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 5),
                              child: Container(
                                decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                                                        color: Theme.of(context).cardColor,
                                                        boxShadow:[
                                                        BoxShadow(
                                                        color: Theme.of(context).shadowColor, // Shadow color
                                                        spreadRadius: 2, // Extends the shadow beyond the box
                                                        blurRadius: 5, // Blurs the edges of the shadow
                                                        offset: const Offset(0, 3), // Moves the shadow slightly down and right
                                                        )]
                                                        ),
                      child: Dismissible(
                            key: ObjectKey(element),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => homeCtrl.deleteDoneTodo(element),
                            background: Container(
                              color: Colors.red.withOpacity(0.8),
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5.0.wp),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 2.0.wp,
                                horizontal: 2.0.wp,
                              ),
                              child: ListTile(
                                          leading: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                                      width: 20,
                                                      height: 20,
                                                      child: Icon(Icons.done_all)
                                                    ),
                                          title: Text(element['title'],
                                          style: const TextStyle(
                                            decoration: TextDecoration.lineThrough,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Quick",
                                                      fontSize: 16),),
                                          subtitle: Row(
                                            children: [
                                            Text(element["exp"] == 0
                                            ? "Side Quest" 
                                            : "Exp :${element["exp"]}",
                                            style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Quick",
                                                      color:Colors.blue.withOpacity(.5),
                                                      fontSize: 14),),
                                                      if(element["coins"] != 0)
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:16),
                                                        child: Row(children: [
                                                        Icon(IconPack.rune_stone,color: Colors.orange.withOpacity(.5),),
                                                          Text(" ${element["coins"]}",
                                                          style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Quick",
                                                        fontSize: 14),)
                                                        ],),
                                                      )
                                          ],),
                                        )
                            ),
                          ),
                    ),
                  ))
                  .toList()
            ],
          )
        : Container());
  }
}
