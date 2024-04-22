import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoingList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeCtrl.doingTodos.isEmpty && homeCtrl.doneTodos.isEmpty
          ? Column(
              children: [
                SizedBox(height: 6.0.wp),
                Image.asset(
                  'assets/images/list.png',
                  fit: BoxFit.cover,
                  width: 65.0.wp,
                ),
                SizedBox(height: 6.0.wp),
                Text(
                  'Add Task',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0.sp,
                  ),
                )
              ],
            )
          : homeCtrl.doingTodos.isEmpty? 
          const Text('Nothing To do for Now (o_o;)',
          style: TextStyle(
            fontFamily: "Quick",
            fontWeight: FontWeight.bold),)
          :ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Align(alignment: Alignment.topCenter,
                  child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.0.wp,
                    horizontal: 5.0.wp,
                  ),
                  child: Text('OnGoing Tasks (${homeCtrl.doingTodos.length})',
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        fontFamily: "Quick",
                        fontWeight: FontWeight.bold,
                      )),
                                ),
                ),
                ...homeCtrl.doingTodos
                    .map((element) => Dismissible(
                        key: ObjectKey(element),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => homeCtrl.deleteDoingTodo(element),
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
                              vertical: 3.0.wp,
                              horizontal: 5.0.wp,
                            ),
                            child: Column(
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        
                                        Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Text.rich(TextSpan(children: [
                                        TextSpan(text:element['title']+"\n"),
                                        TextSpan(text:element["exp"] == 0? "Free Quest" : "Exp :${element["exp"]}",style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Quick",
                                          color:Colors.blue,
                                          fontSize: 16), )
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
                      
                                          //
                                          SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                      
                                            
                                            value: element['done'],
                                            onChanged: (value) {
                                              homeCtrl.doneTodo(element['title'],element["exp"]);
                                            },
                                          ),
                                        ),
                                  ],
                                ),
                                if(!(element == homeCtrl.doingTodos.last))
                                 Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Divider(color:Theme.of(context).iconTheme.color!.withOpacity(.4)),
                                )
                              ],
                            ),
                          ),
                    ))
                    .toList(),
                if (homeCtrl.doingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child:  Divider(
                      color:Theme.of(context).iconTheme.color!.withOpacity(.4),
                      thickness: 1,
                    ),
                  )
              ],
            ),
    );
  }
}

