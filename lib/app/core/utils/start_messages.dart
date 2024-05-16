import 'package:flutter/material.dart';


List <Widget> start =[limit(),over(),you(),showThem(),loose(),lesson(),lesson2(),level()];
Widget limit(){
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
                 padding: const EdgeInsets.all(12),
                 child: Center(
                   child: Text.rich(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Quick",
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ),
                    TextSpan(children: [
                    TextSpan(text:" Surpass Your"),
                    TextSpan(text: " Limit ",style: TextStyle(color: Colors.red)),
                    TextSpan(text: "Here And Now"),
                   ])),
                 ),
               ),
    ],
  );
}

Widget over(){
  return  Padding(
             padding: const EdgeInsets.all(12),
             child: Text.rich(
              style: TextStyle(
                fontFamily: "Quick",
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
              TextSpan(children: [
              TextSpan(text:" Is That"),
              TextSpan(text: " All ",style: TextStyle(color: Colors.blue)),
              TextSpan(text: "You got ?"),
             ])),
           );
}

Widget you(){
  return  Padding(
             padding: const EdgeInsets.all(12),
             child: Text.rich(
              style: TextStyle(
                fontFamily: "Quick",
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
              TextSpan(children: [
              TextSpan(text:" Become"),
              TextSpan(text: " The You "),
              TextSpan(text: "Who Surpass Everyone Else",style: TextStyle(color: Colors.purple)),
             ])),
           );
}

Widget showThem(){
  return  Padding(
             padding: const EdgeInsets.all(12),
             child: Text.rich(
              style: TextStyle(
                fontFamily: "Quick",
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
              TextSpan(children: [
              TextSpan(text:" Show Them"),
              TextSpan(text: " What "),
              TextSpan(text: "You Truly Are",style: TextStyle(color: Colors.teal)),
             ])),
           );
}

Widget loose(){
  return  Padding(
             padding: const EdgeInsets.all(12),
             child: Text.rich(
              style: TextStyle(
                fontFamily: "Quick",
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
              TextSpan(children: [
              TextSpan(text:" You Only Loose"),
              TextSpan(text: " When You "),
              TextSpan(text: "Believe You Did",style: TextStyle(color: Colors.red)),
             ])),
           );
}

Widget lesson(){
  return  Padding(
             padding: const EdgeInsets.all(12),
             child: Text.rich(
              style: TextStyle(
                fontFamily: "Quick",
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
              TextSpan(children: [
              TextSpan(text:" If You Never "),
              TextSpan(text: " Try "),
              TextSpan(text: "You Will Never Know",style: TextStyle(color: Colors.red)),
             ])),
           );
}

Widget lesson2(){
  return  Padding(
             padding: const EdgeInsets.all(12),
             child: Text.rich(
              style: TextStyle(
                fontFamily: "Quick",
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
              TextSpan(children: [
              TextSpan(text:" Will Never Try"),
              TextSpan(text: " And Stay Forever "),
              TextSpan(text: " As You Are Now ?",style: TextStyle(color: Colors.red)),
             ])),
           );
}

Widget level(){
  return  Padding(
               padding: const EdgeInsets.all(12),
               child: Text.rich(
               TextSpan(children:[
                TextSpan(text:  "Ready For The Next ",style: TextStyle()),
                TextSpan(text: "Level ?",style: TextStyle(color:Colors.purple)),
                TextSpan(text: "",style: TextStyle())]),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: "Quick"),),
             );
}
