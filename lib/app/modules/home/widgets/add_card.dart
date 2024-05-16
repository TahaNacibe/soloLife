import 'package:SoloLife/app/core/utils/Keys.dart';
import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/core/values/colors.dart';
import 'package:SoloLife/app/data/models/achivments.dart';
import 'package:SoloLife/app/data/models/task.dart';
import 'package:SoloLife/app/data/services/expScal/exp.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:SoloLife/app/widgets/icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  final void Function() change;
  AddCard({super.key, required this.change});

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    return Container(
      //width: squareWidth / 2,
      //height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onLongPress:(){
          achievementsHandler("box",context);
          Navigator.popAndPushNamed(context, "commandPage");
        },
        onDoubleTap:change,
        onTap: () async {

          await Get.defaultDialog(
            radius:20,
              titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
              title: 'New Collection',
              titleStyle: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,),
              content: Form(
                key: homeCtrl.formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                      child: Container(padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Theme.of(context).iconTheme.color!.withOpacity(.2),width: 1.5)
                      ),
                        child: TextFormField(
                          cursorColor: Theme.of(context).iconTheme.color,
                          controller: homeCtrl.editCtrl,
                          decoration:  InputDecoration(
                            contentPadding: EdgeInsets.only(left:8),
                             border: InputBorder.none,
                            labelText: 'Collection name',
                            labelStyle: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.w500,)
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your task title';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                      child: Wrap(
                        spacing: 2.0.wp,
                        children: icons
                            .map((e) => Obx(() {
                                  final index = icons.indexOf(e);
                                  return ChoiceChip(
                                    selectedColor: Colors.grey[200],
                                    pressElevation: 0,
                                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Set border radius
                  side: BorderSide(
                    color: Theme.of(context).iconTheme.color!.withOpacity(.2), 
                    width: .5), // Set border color and width
                ),
                                    backgroundColor: Colors.white,
                                    label: e,
                                    selected: homeCtrl.chipIndex.value == index,
                                    onSelected: (bool selected) {
                                      homeCtrl.chipIndex.value =
                                          selected ? index : 0;
                                    },
                                  );
                                }))
                            .toList(),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(150, 40)),
                        onPressed: () {
                          if (homeCtrl.formKey.currentState!.validate() && !reservedNames.contains(homeCtrl.editCtrl.text)) {
                            int icon =
                                icons[homeCtrl.chipIndex.value].icon!.codePoint;
                            String color =
                                icons[homeCtrl.chipIndex.value].color!.toHex();
                            var task = Task(
                              title: homeCtrl.editCtrl.text,
                              icon: icon,
                              color: color,
                            );
                            Get.back();
                            if(homeCtrl.addTask(task)){
                               EasyLoading.showSuccess('Create successfully');
                            }else{
                              //? the duplicated task
                            achievementsHandler("double",context);
                              EasyLoading.showError('Duplicated Task');
                            }
                          }else{
                            EasyLoading.showError('Use Deferent Name please');
                          }
                        },
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Create',
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(Icons.add,color: Colors.white,)
                          ],
                        ))
                  ],
                ),
              ));
          homeCtrl.editCtrl.clear();
          homeCtrl.changeChipIndex(0);
        },
        child: DottedBorder(
          radius: Radius.circular(15),
            color: Colors.grey[400]!,
            dashPattern: const [8, 4],
            child: Center(
              child: Icon(
                Icons.add,
                size: 10.0.wp,
                color: Colors.grey,
              ),
            )),
      ),
    );
  }
}
