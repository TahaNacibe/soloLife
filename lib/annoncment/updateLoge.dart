import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_dialogs/dialogs.dart';

void updateDialog(BuildContext context, void Function() onTap){
  Dialogs.materialDialog(
    msg: ''' 
    1- fix bugs in the class system
    2- class now can tell the grade too
    3- long press the class to se the number
    ''',
          title: "Update Note",
          titleStyle: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green),
          msgStyle: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.w600,fontSize: 15),
          color: Theme.of(context).cardColor,
          context: context,
          
          );
}