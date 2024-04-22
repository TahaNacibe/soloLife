import 'package:SoloLife/app/core/utils/Keys.dart';
import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/core/values/colors.dart';
import 'package:SoloLife/app/data/models/task.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:SoloLife/app/widgets/icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWidth = Get.width - 12.0.wp;
    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onLongPress:(){
          Navigator.popAndPushNamed(context, "commandPage");
        },
        onTap: () async {
          await Get.defaultDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
              radius: 5,
              title: 'Task Type',
              content: Form(
                key: homeCtrl.formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                      child: TextFormField(
                        cursorColor: Theme.of(context).iconTheme.color,
                        controller: homeCtrl.editCtrl,
                        decoration:  InputDecoration(
                           focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                           ),
                          border: OutlineInputBorder(),
                          labelText: 'title',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your task title';
                          }
                          return null;
                        },
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
                            homeCtrl.addTask(task)
                                ? EasyLoading.showSuccess('Create successfully')
                                : EasyLoading.showError('Duplicated Task');
                          }else{
                            EasyLoading.showError('Use Deferent Name please');
                          }
                        },
                        child: const Text(
                          'confirm',
                          style: TextStyle(color: Colors.white),
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
