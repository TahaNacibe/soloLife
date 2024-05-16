import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String description,
  required IconData icon,
  String actionButton1Text = 'Cancel',
  String actionButton2Text = 'Confirm',
  required void Function() actionButton1Callback,
  required void Function() actionButton2Callback,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 72,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(description,
            style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 16)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                        GestureDetector(
              onTap: () {
                  actionButton1Callback();
              },
              child:Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.indigo
              ),
                child: Text(actionButton1Text,
                style: TextStyle(
                  fontFamily: "Quick",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18)),
              ),
                        ),
                        GestureDetector(
              onTap: () {
                  actionButton2Callback();
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.orange
              ),
                child: Text(actionButton2Text,
                style: TextStyle(
                  fontFamily: "Quick",
                  color:Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
              ),
                        ),
                      ],),
            )
          ],
        ),
        
      );
    },
  );
}
