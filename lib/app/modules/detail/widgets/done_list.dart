import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/core/values/colors.dart';
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
                  child: Text('Finished Tasks (${homeCtrl.doingTodos.length})',
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        fontFamily: "Quick",
                        fontWeight: FontWeight.bold,
                      )),
                                ),
                ),
              ...homeCtrl.doneTodos
                  .map((element) => Dismissible(
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
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 3.0.wp,
                                horizontal: 9.0.wp,
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                       Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Text.rich(TextSpan(children: [
                                      TextSpan(text:element['title']+"\n",style: TextStyle(decoration: TextDecoration.lineThrough)),
                                      TextSpan(text:element["exp"] == 0? "Free Quest" : "Exp :${element["exp"]}",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Quick",
                                        color:Colors.blue.withOpacity(.7),
                                        fontSize: 16), ),
                                         TextSpan(
                                            text:" coins:${element["coins"] ?? "free"}",
                                            style: TextStyle(color:Colors.orange)
                                          )
                                      ])
                                      ,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(

                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Quick",
                                        fontSize: 15),
                                    ),
                                  ),
                                  
                                    ],
                                  ),
                                  const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Icon(
                                          Icons.done,
                                          color: blue,
                                        ),
                                      ),
                                ],
                              ),
                            ),
                             Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(color:Theme.of(context).iconTheme.color!.withOpacity(.4)),
                          )
                          ],
                        ),
                      ))
                  .toList()
            ],
          )
        : Container());
  }
}
