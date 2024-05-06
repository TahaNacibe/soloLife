import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/modules/detail/widgets/doing_list.dart';
import 'package:SoloLife/app/modules/detail/widgets/done_list.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:SoloLife/app/modules/home/widgets/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DreamPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.task.value!;
    bool isClosed = true;
    bool isFree = false;
    String userPassword = ProfileProvider().readProfile().password;
    bool isLocked = userPassword.isNotEmpty;

    TextEditingController controller = TextEditingController();
    String message = "";
    var color = HexColor.fromHex(task.color);
    return 
       StatefulBuilder(
        builder: (context,setState) {
          return 
              WillPopScope(
                onWillPop: () async => true,
                child: Scaffold(
                    body: Stack(
                      children: [
                        Form(
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
                      var ongoingTodo = homeCtrl.doingTodos.length;
                      var doneTodo = homeCtrl.doneTodos.length; 
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 14.0.wp,
                          right: 14.0.wp,
                          top: 1.0.wp,
                        ),
                        child: Column(
                          children: [
                             Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                actionBarItem("onGoing","$ongoingTodo",color,false),
                                actionBarItem("Finished","$doneTodo",color,false),
                                actionBarItem("Tasks","$totalTodos",color,false),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  
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
                            ),
                           
                          ],
                        ),
                      );
                    }),
                 Padding(
                      padding: const EdgeInsets.symmetric(horizontal:60),
                      child: Divider(color: Theme.of(context).iconTheme.color!.withOpacity(.2),),
                    ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 0.0.wp,
                    horizontal: 3.0.wp,
                  ),
                  child: TextFormField(
                    cursorColor: Theme.of(context).iconTheme.color,
                    controller: homeCtrl.editCtrl,
                    decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                          enabledBorder:const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom:10,right: 8),
                          child: GestureDetector(
                            onTap:(){
                               isFree = !isFree;
                              setState((){});
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                border: Border.all(color:isFree? Colors.red : Colors.blue),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                isFree? "No Exp" : "Exp",
                              style: TextStyle(
                                color: isFree? Colors.red : Colors.blue,
                                fontFamily:"Quick",
                                fontWeight: FontWeight.w600),),
                            ),
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (homeCtrl.formKey.currentState!.validate()) {
                              var success =
                                  homeCtrl.addTodo(homeCtrl.editCtrl.text,isFree);
                              if (success) {
                                EasyLoading.showSuccess('Todo item add success');
                                homeCtrl.updateTodos();
                                  //homeCtrl.changeTask(null);
                              } else {
                                EasyLoading.showError('Todo item already exists');
                              }
                              homeCtrl.editCtrl.clear();
                            }
                          },
                          icon: Container(padding: const EdgeInsets.all(12),
                          decoration:BoxDecoration(
                    color: color,
                    //shape: BoxShape.circle
                    borderRadius: BorderRadius.circular(10)
                                    ),
                            child: const Icon(Icons.add,color:Colors.white)),
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
              child: Column(
                children: [
                            
                  DoingList(),
              DoneList(),
                ],
              ),
            ),
          ],
        ),
      ),
                      
              
              if(isClosed && isLocked)
              Container(
                color: Theme.of(context).cardColor,
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
                child: Column(
                  
                  children:[Row(
                    children: [
                      
                      
                    ],
                  ),
                  const SizedBox(height: 100,),
                  CircleAvatar(
                    backgroundColor: color,
                    radius: 40,
                    child: Container(padding: const EdgeInsets.all(18),
                        decoration:BoxDecoration(
                  color: color,
                  shape: BoxShape.circle
                                  ),
                        child: Icon(
                          IconData(
                            task.icon,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: Colors.white,
                        ),
                      ),
                  ),
                  SizedBox(height: 50,),
                    const Text("Dream Space is Locked",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Quick",
                    fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        obscureText: true,
                        controller: controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 12),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).iconTheme.color!.withOpacity(.4)),
                            borderRadius: BorderRadius.circular(15)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).iconTheme.color!.withOpacity(.4)),
                            borderRadius: BorderRadius.circular(15))),
                        style:const TextStyle(
                        fontSize: 20,
                        fontFamily: "Quick",
                      fontWeight: FontWeight.bold) ,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle                    ),
                        child: IconButton(onPressed:(){
                          if (controller.text == userPassword) {
                            isClosed = false;
                            setState((){});
                          }else{
                            message = "password incorrect";
                            setState((){});
                          }
                        }, icon: const Icon(
                          color:Colors.white,
                          Icons.arrow_forward)),
                      ),
                    ),
                    Text(message,style: const TextStyle(fontFamily: "Quick",fontSize: 20,fontWeight: FontWeight.bold,color:Colors.red),)
                  ],
                ),
              ),)
                      ])));
        }
    );
  }
}
