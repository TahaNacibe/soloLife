import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoingList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoingList({super.key});

  // Initializing variables
  bool isOrdering = false;
  int indexFor = 999999999;

  @override
  Widget build(BuildContext context) {

    // Getting the current task from homeCtrl
  var task = homeCtrl.task.value!;
    var color = HexColor.fromHex(task.color);

    return Obx(
      // Returning a widget based on the state of doingTodos and doneTodos

      () => homeCtrl.doingTodos.isEmpty && homeCtrl.doneTodos.isEmpty
          ? Column(
              children: [
                SizedBox(height: 6.0.wp),
                Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Quick",
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                  ),
                  "Why its' too empty here ?\n"),
                SizedBox(height: 6.0.wp),
                Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Quick",
                    fontWeight: FontWeight.bold,
                    color:color,
                    fontSize: 30
                  ),
                  "(0o0?)"),
                
              ],
            )
          : homeCtrl.doingTodos.isEmpty? 
          const Text('Nothing To do for Now (o_o;)',
          style: TextStyle(
            fontFamily: "Quick",
            fontSize: 22,
            fontWeight: FontWeight.bold),)
          :Column(
            children: [Align(alignment: Alignment.topCenter,
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
                            child: Text('OnGoing Tasks',
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
              StatefulBuilder(
                builder: (context,setState) {
                  return ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = homeCtrl.doingTodos.removeAt(oldIndex);
                    homeCtrl.doingTodos.insert(newIndex, item);
                    homeCtrl.doingTodos.refresh();
                  });
                },
                proxyDecorator: (Widget child, int index, Animation<double> animation) {
      return Material(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 1.5)
          ),
          child: child,
        ),
      );
    },
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        ...homeCtrl.doingTodos
                            .map((element) => Padding(
                                key: ObjectKey(element),
                              padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 5),
                              child: Container(
                                decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                                                        color: Theme.of(context).cardColor,
                                                        boxShadow:[
                                                        BoxShadow(
                                                        color:Theme.of(context).shadowColor, // Shadow color
                                                        spreadRadius: 2, // Extends the shadow beyond the box
                                                        blurRadius: 5, // Blurs the edges of the shadow
                                                        offset: const Offset(0, 3), // Moves the shadow slightly down and right
                                                        )]
                                                        ),
                                child: Dismissible(
                                    key: ObjectKey(element),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (_) async{
                                      bottomShit(context,element,(){
                                        setState((){});
                                      });
                                      return false;
                                    },
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
                                          trailing: Icon(Icons.menu,size: 30,),
                                          leading: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                                      width: 20,
                                                      height: 20,
                                                      child: Checkbox(
                                                  
                                                        
                                                        value: element['done'],
                                                        onChanged: (value) {
                                                          element['coins'] = element['coins'] ?? 0;
                                                          print(element);
                                                          homeCtrl.doneTodo(element['title'],element["exp"], element['coins'],context);
                                                          homeCtrl.updateTodos();
                                                          
                                                        },
                                                      ),
                                                    ),
                                          title: Text(element['title'],
                                          style: const TextStyle(
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
                                                      color:Colors.blue.withOpacity(.8),
                                                      fontSize: 14),),
                                                      if(element["coins"] != 0)
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:16),
                                                        child: Row(children: [
                                                        Icon(IconPack.rune_stone,color: Colors.orange,),
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
                            .toList(),
                        
                      ],
                    );
                }
              ),
            ],
          ),
    );
  }
// Function to show a bottom sheet for deleting a task
  void bottomShit(BuildContext context, var element,void Function() refresh) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: 300,
            child: Column(
              children: [
                Stack(alignment: Alignment.bottomCenter,
                  children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.vertical(top:Radius.circular(15) )
                      ),),
                    Align(alignment: Alignment.bottomCenter,
                      child: Icon(Icons.delete_outline_rounded,color: Colors.red,size: 100,)),
                  ],
                ),
                Container(decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  
                ),
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text.rich(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            TextSpan(
                            style: TextStyle(
                              fontFamily: "Quick",
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                            children:[
                            TextSpan(
                              text: "Want to delete ",
                            ),
                            TextSpan(
                              text: "${element['title']} ",
                              style: TextStyle(
                                color: Colors.red
                              )
                            ),
                            TextSpan(
                              text: "?\n"
                            )
                          ])),
                        ),
                        Text("You wont get any Exp or Credit if you delete it",
                        style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.w600),),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                refresh();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color:Colors.blue)
                                ),
                                child: Text("Cancel",
                                style: TextStyle(
                                  fontFamily: "Quick",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue,
                                  fontSize: 17),)),
                            ),
                            GestureDetector(
                              onTap: () {
                                homeCtrl.deleteDoingTodo(element);
                                homeCtrl.updateTodos();
                                setState(() {}); // Refresh the UI
                                Navigator.pop(context); // Close the bottom sheet
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color:Colors.red)
                                ),
                                child: Text("Delete",
                                style: TextStyle(
                                  fontFamily: "Quick",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                  fontSize: 17),)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

}

