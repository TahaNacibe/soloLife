import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  // initialize the controllers
    TextEditingController enteringController = TextEditingController();
    TextEditingController createController = TextEditingController();
    TextEditingController checkController = TextEditingController();
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();
    // read the user data
    Profile user = ProfileProvider().readProfile();
    // initialize the vars
    String openMessage = "";
    String message = "";
    bool forget =false;

  @override
  Widget build(BuildContext context) {
    // initialize the vars
    List<String> parts = user.forgetPassword.split(":");
    bool isClosed = user.password.isNotEmpty;
    String userPassword = user.password;

    return Scaffold(
      appBar: AppBar(title: Text("Password Manager",
      style: TextStyle(
        fontFamily: "Quick",
        fontWeight: FontWeight.bold,
        fontSize: 16
      ),),),
      body: StatefulBuilder(
        builder: (context,setState) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).cardColor,
                            boxShadow:[BoxShadow(
                      color: Theme.of(context).shadowColor, // Shadow color
                      spreadRadius: 1, // Extends the shadow beyond the box
                      blurRadius: 5, // Blurs the edges of the shadow
                      offset: const Offset(0, 3), // Moves the shadow slightly down and right
                      )]
                          ),
                            child: Column(
                              children: [
                                Stack(alignment: Alignment.centerLeft,
                          children: [
                            Divider(),
                            Container(
                              color: Theme.of(context).cardColor,
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Create Password',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Quick",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text("Password will only lock the Dream Space so activate it to use password",
                                  style: TextStyle(
                                    fontFamily: "Quick",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                  titleBar("Password"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: inputBar(createController,"Enter Password"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: inputBar(checkController,"Re-Enter Password"),
                  ),
                  titleBar("Security Question"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(style: TextStyle(
                      fontFamily: "Quick",
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 12
                    ),
                      "If you already have an question you can skip that part no need to update it if you don't want to"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: inputBar(questionController,"question to get password back"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: inputBar(answerController,"Answer"),
                  ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(openMessage,
                    style: TextStyle(
                      color: openMessage.contains("Updated")? Colors.green : Colors.red,
                      fontFamily: "Quick",
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
                  ),
                  GestureDetector(
                    onTap:(){
                      // if every field is okay 
                      if(createController.text.isNotEmpty && createController.text == checkController.text){
                        if(questionController.text.isNotEmpty && answerController.text.isNotEmpty){
                          user.password = createController.text;
                          user.forgetPassword = "${questionController.text}:${answerController.text}";
                          ProfileProvider().saveProfile(user, "", context);
                          openMessage = "Password Updated";
                          Navigator.pop(context);
                          setState(() {});
                          // problems 
                        }else if(user.forgetPassword.isNotEmpty && questionController.text.isEmpty && answerController.text.isEmpty){
                        user.password = createController.text;
                        ProfileProvider().saveProfile(user, "", context);
                          openMessage = "Password Updated";
                          Navigator.pop(context);
                          setState(() {});
                        }else{
                          openMessage = "require both question and answer";
                          setState(() {});
                        }
                      }else{
                        openMessage = createController.text.isNotEmpty? "Password doesn't match" :"Password can't be empty";
                        print(openMessage);
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 40,vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.indigo
                      ),
                      child: Text(isClosed? "Update" : "Set Password",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quick"),),),
                  ),
                SizedBox(height: 50,),
                ],),
              ),
              if(isClosed)
              Container(color: Theme.of(context).cardColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom:50),
                      child: Icon(Icons.lock,color: Colors.indigo,size: 70,),
                    ),
                        Text(
                          textAlign: TextAlign.center,
                          forget?  "Answer Question to enter\n${parts[0]}?" :"Enter Password to continue",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Quick",
                        fontWeight: FontWeight.bold),),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: TextField(
                            obscureText: true,
                            controller: enteringController,
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
                          padding: const EdgeInsets.only(right:20),
                          child: Align(alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap:(){
                                if(parts.length < 2){
                                  message = "no recover question registered";
                                  setState((){});
                                }else{
                                forget = !forget;
                                setState((){});
                                }
                              },
                              child: Text(forget? "Enter Password" :"Forget password?",style: TextStyle(color: Colors.indigo,fontFamily: "Quick",fontWeight: FontWeight.bold,fontSize: 15),))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle                    ),
                            child: IconButton(onPressed:(){
                              if(!forget){
                              if (enteringController.text == userPassword) {
                                isClosed = false;
                                setState((){});
                              }else{
                                message = "password incorrect";
                                setState((){});
                              }
                              }else{
                                if(parts[1] == enteringController.text){
                                  isClosed = false;
                                setState((){});
                                }else{
                                message = "Wrong Answer";
                                setState((){});
                              }
                              }
                            }, icon: const Icon(
                              color:Colors.white,
                              Icons.arrow_forward)),
                          ),
                        ),
                        Text(message,style: const TextStyle(fontFamily: "Quick",fontSize: 20,fontWeight: FontWeight.bold,color:Colors.red),)
          
                ],)),
            ],
          );
        }
      ),
    );
  }

  Widget titleBar(String title){
    return Padding(padding:EdgeInsets.symmetric(horizontal: 12),
                  child: Stack(alignment: Alignment.centerLeft,
                    children: [
                      Divider(),
                      Container(
                        color: Theme.of(context).cardColor,
                        padding: EdgeInsets.all(8),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),);
  }
  Widget inputBar(TextEditingController controller1,String hint){
    bool show = (hint.contains("answer") || hint.contains("get"))? false : true;
    return StatefulBuilder(
      builder: (context,setState) {
        return Padding(
                          padding: const EdgeInsets.all(14),
                          child: Container(decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).iconTheme.color!.withOpacity(.5),width: .5),
                            borderRadius: BorderRadius.circular(15)
                          ),
                            child: TextField(
                              obscureText: show,
                              controller: controller1,
                              decoration: InputDecoration(
                                suffix: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap:(){
                                      show = !show;
                                      setState(() {
                                        
                                      });
                                    },
                                    child: Icon(Icons.password)),
                                ),
                                hintText: hint,
                                hintStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),
                                contentPadding: EdgeInsets.only(left: 12),
                                border: InputBorder.none,),
                              style:const TextStyle(
                              fontSize: 18,
                              fontFamily: "Quick",
                            fontWeight: FontWeight.bold) ,
                            ),
                          ),
                        );
      }
    );
  }
}