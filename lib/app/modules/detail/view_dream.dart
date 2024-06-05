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

    // Initializing variables
    var task = homeCtrl.task.value!;
    bool isClosed = true;
    bool isFree = false;
    String userPassword = ProfileProvider().readProfile().password;
    bool isLocked = userPassword.isNotEmpty;
    String message = "";
    var color = HexColor.fromHex(task.color);
    // Initializing controller
    TextEditingController controller = TextEditingController();
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
            Container(
                  decoration:BoxDecoration(
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                        color: Theme.of(context).cardColor,
                        boxShadow:[
                        BoxShadow(
                        color: Theme.of(context).shadowColor, // Shadow color
                        spreadRadius: 2, // Extends the shadow beyond the box
                        blurRadius: 5, // Blurs the edges of the shadow
                        offset: const Offset(0, 6), // Moves the shadow slightly down and right
                        )]
                        ),
                  child: Column(children:[
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                          decoration: 
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration:BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  //topLeft: Radius.circular(10),
                                                  bottomRight: Radius.circular(10))
                                          ),
                                child: Icon(
                                  IconData(
                                    task.icon,
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  color: color,
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
                        ),
                      ),
                       Row(
                         children: [
                           //ToDo change that in this case if the user close the app in the create task it wont save
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color
                             ),
                               child: GestureDetector(
                                 onTap: () {
                                   Get.back();
                                   homeCtrl.updateTodos();
                                   homeCtrl.editCtrl.clear();
                                   Navigator.popAndPushNamed(context, "HomePage");
                                 },
                                 child: const Icon(Icons.close,color: Colors.white,),
                               ),
                             ),
                           )
                         ],
                       ),
                    ],
                  ),
                  Obx(() {
                    // Initializing variables for observation of the obx
                    var totalTodos =
                        homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
                    var ongoingTodo = homeCtrl.doingTodos.length;
                    var doneTodo = homeCtrl.doneTodos.length; 

                    // the Ui
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
                              actionBarItem("onGoing","$ongoingTodo",color,false,20,18),
                              actionBarItem("Finished","$doneTodo",color,false,20,18),
                              actionBarItem("Tasks","$totalTodos",color,false,20,18),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Container(decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                                          color: Theme.of(context).cardColor,
                                                          
                                                          
                                                          ),
                    child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 0.0.wp,
                      horizontal: 3.0.wp,
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: "Quick",
                        fontWeight: FontWeight.bold
                      ),
                      textAlignVertical: TextAlignVertical.center,
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
                                  border: Border.all(color:isFree?Colors.blue  :Colors.red ),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(isFree?  Icons.star_border:Icons.star ,color:isFree?  Colors.blue:Colors.red ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      isFree?  " Side":" Main" ,
                                    style: TextStyle(
                                      color: isFree?  Colors.blue: Colors.red,
                                      fontFamily:"Quick",
                                      fontWeight: FontWeight.w600),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (homeCtrl.formKey.currentState!.validate()) {
                                var success =
                                    homeCtrl.addTodo(homeCtrl.editCtrl.text,isFree,context);
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
                                    ),
                  ),
                ),
                                ]),
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
                      // check if the password exit
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
                  children:[
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
