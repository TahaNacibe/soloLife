import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/modules/detail/widgets/doing_list.dart';
import 'package:SoloLife/app/modules/detail/widgets/done_list.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DetailPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.task.value!;
    var color = HexColor.fromHex(task.color);
    return PopScope(
      canPop: true,
      onPopInvoked: (_){
        homeCtrl.updateTodos();
        homeCtrl.changeTask(null);
        homeCtrl.editCtrl.clear();
      },
      child: Scaffold(
          body: Form(
        key: homeCtrl.formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(3.0.wp),
              child: Row(
                children: [
                  //ToDo change that in this case if the user close the app in the create task it wont save
                  IconButton(
                    onPressed: () {
                      Get.back();
                      homeCtrl.updateTodos();
                      homeCtrl.changeTask(null);
                      homeCtrl.editCtrl.clear();
                    },
                    icon: const Icon(Icons.arrow_back),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).cardColor,
                      boxShadow:[BoxShadow(
                      color: Theme.of(context).shadowColor, // Shadow color
                      spreadRadius: 2, // Extends the shadow beyond the box
                      blurRadius: 5, // Blurs the edges of the shadow
                      offset: const Offset(0, 3), // Moves the shadow slightly down and right
                      )]
                      ),
                child: Column(children:[Row(
                  children: [
                    Container(padding: const EdgeInsets.all(12),
                      decoration:BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))
                                ),
                      child: Icon(
                        IconData(
                          task.icon,
                          fontFamily: 'MaterialIcons',
                        ),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 3.0.wp,
                    ),
                    Text(
                      task.title,
                      style: TextStyle(
                        fontFamily: "Quick",
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Obx(() {
                  var totalTodos =
                      homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 16.0.wp,
                      right: 16.0.wp,
                      top: 3.0.wp,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$totalTodos Tasks',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 3.0.wp),
                        Expanded(
                            child: StepProgressIndicator(
                              roundedEdges: Radius.circular(15),
                          totalSteps: totalTodos == 0 ? 1 : totalTodos,
                          currentStep: homeCtrl.doneTodos.length,
                          size: 5,
                          padding: 0,
                          selectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color.withOpacity(0.5), color],
                          ),
                          unselectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey[300]!, Colors.grey[300]!],
                          ),
                        ))
                      ],
                    ),
                  );
                }),
                Divider(color: Theme.of(context).iconTheme.color!.withOpacity(.4),),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 1.0.wp,
                horizontal: 5.0.wp,
              ),
              child: TextFormField(
                cursorColor: Theme.of(context).iconTheme.color,
                controller: homeCtrl.editCtrl,
                autofocus: true,
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                      enabledBorder:const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(bottom:10),
                      child: Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.grey[400],
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (homeCtrl.formKey.currentState!.validate()) {
                          var success =
                              homeCtrl.addTodo(homeCtrl.editCtrl.text);
                          if (success) {
                            EasyLoading.showSuccess('Todo item add success');
                          } else {
                            EasyLoading.showError('Todo item already exists');
                          }
                          homeCtrl.editCtrl.clear();
                        }
                      },
                      icon: Container(padding: const EdgeInsets.all(12),
                      decoration:BoxDecoration(
                color: color,
                shape: BoxShape.circle
                                ),
                        child: const Icon(Icons.done,color:Colors.white)),
                    )),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your todo item';
                  }
                  return null;
                },
              ),
            ),]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(padding: const EdgeInsets.all(12),
                  decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black.withOpacity(.2)),
                        color: Theme.of(context).cardColor,
                        boxShadow:[BoxShadow(
                        color:Theme.of(context).shadowColor, // Shadow color
                        spreadRadius: 2, // Extends the shadow beyond the box
                        blurRadius: 5, // Blurs the edges of the shadow
                        offset: const Offset(0, 3), // Moves the shadow slightly down and right
                        )]
                        ),
                child: Column(
                  children: [
              
                    DoingList(),
                DoneList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}


