import 'package:SoloLife/app/data/models/achivments.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'voiceCommand/service.dart';


class CommandPage extends StatefulWidget {
  const CommandPage({Key? key}) : super(key: key);

  @override
  _CommandPageState createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  bool commandLine = false;
  TextEditingController command = TextEditingController();
  String result = "";
  String response = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      response = authorityLevel(_wordsSpoken.toLowerCase(),context);
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Stack(alignment: Alignment.topCenter,
          children: [
            Container(color:Colors.black,
              child: Column(children: [
                Image.asset("assets/images/giphy.gif"),
                Expanded(
                  child: Container(
                    decoration:  BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                    ),
                    
                    child:  ListView(
                      shrinkWrap: true,
                    children: [
                      if(!commandLine)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _speechToText.isListening
                              ? "listening..."
                              : _speechEnabled
                                  ? "Tap the microphone to start listening..."
                                  : "Speech not available",
                          style: const TextStyle(fontSize: 20.0,fontFamily: "Quick",fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                    padding: const EdgeInsets.all(16),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: _wordsSpoken + "\n"),
                        TextSpan(text: "\n"),
                        TextSpan(text:">>" + response,style: TextStyle(color:Colors.green))
                      ]),
                      style: const TextStyle(
                        fontSize: 25,
                        fontFamily: "Quick",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                    ],
                  ),
                  
                    if(commandLine)
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        cursorColor: Theme.of(context).iconTheme.color,
                        autofocus: true,
                        controller: command,
                        style: const TextStyle(
                          fontFamily: "Quick",
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          prefix: const Text(" >> ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            ),),
                          suffix:  Container(padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color:Colors.black,
                              shape: BoxShape.circle),
                            child: GestureDetector(onTap: (){
                                              result = authorityLevel(command.text,context);
                                              command.clear();
                                              if(result != "Not recognized command" && result != "only master level can use commands !! " ){
                                                achievementsHandler("hax",context);
                                              }
                                              setState((){});
                                            }, child:  const Icon(Icons.arrow_forward_ios,color:Colors.white)),
                          ),
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(">> $result",style:const TextStyle(
                        fontSize: 18,
                        fontFamily: "Quick",
                        fontWeight: FontWeight.bold),),
                    )
                  ],)
                                ],
                              ),),
                )
              ],),
            ),
            Container(
              width: 100,
              decoration:BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15)
              ),
              child:Row(children: [
                IconButton(onPressed:(){
                  Navigator.popAndPushNamed(context, "HomePage");
                }, icon: Icon(Icons.close)),
                Text("Box",style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold),)
              ],))
          ],
        ),
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: (_speechToText.isListening && !commandLine) ? _stopListening : _startListening,
        tooltip: 'Listen',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Colors.black,
        child: GestureDetector(
          onLongPress: () {
            commandLine = !commandLine;
           
            setState((){});
          },
          child: Icon(
           commandLine? Icons.text_fields : (_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

