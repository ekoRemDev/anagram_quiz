import 'package:anagram_quiz/letter.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'dart:math';
import 'config/config.dart';
import 'config/mixin_functions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin, MixinFunctions {

  Timer _timer;
  int _start = game_length;
  Color timerColor = timerControlColors00;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;

            if(_start == 0 ){

              // game over vibration
              Vibration.vibrate(duration: 300);

            }

          }
        },
      ),
    );
  }


  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  var alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];

  List<String> wordList = ["DOMATES","PATATES","KARPUZ","KAVUN","PEYNIR","SOGUKSU","BALIK","BUZ","BARDAK","RAKI"];

  String questionWord = "";

  List<String> letterList = [];
  List<int> letterIndexList = [];
  List<int> letterSelected = [];
  List<String> solution = [];
  List<int> solutionIndexList = [];
  List<String> board = [];

  List<Letter> letterList2 = [];
  bool dragCompleted = false;

  void generateWord(){
    var rng = new Random();
    for (var i = 0; i < 10; i++) {
      print(rng.nextInt(100));
    }

    setState(() {
      questionWord = wordList[rng.nextInt(10)];
    });

  }

  void createListFromSentences(String word) {
    letterList = word.split("").toList();

    for (int i=0; i<letterList.length;i++) {
      for (int j = 0 ; j< alphabet.length; j++) {
        if(letterList[i] == alphabet[j])


          letterList2.add(new Letter(letter: letterList[i], alphabetIndex: j,letterStatus: 0));


          solutionIndexList.add(j);
      }
    }


    for (int i=0; i<letterList.length;i++) {
      board.add("*");
      letterSelected.add(0);
    }


//    print("----index list is-----");
//    print(letterIndexList);

    _shuffleList();
  }

  void createSolution(String word) {
    solution = word.split("").toList();
    print("This is solution");
    print(solution);
  }

  void _shuffleList() {
//    setState(() {
//      letterList.shuffle();
//
//      letterIndexList.clear();
//
//      for (int i=0; i<letterList.length;i++) {
//        for (int j = 0 ; j< alphabet.length; j++) {
//          if(letterList[i] == alphabet[j])
//            letterIndexList.add(j);
//            letterSelected.add(letterSelected[j]);
//        }
//      }
//
//
//
//
//    });

    setState(() {
      letterList2.shuffle();

      letterIndexList.clear();

      for (int i=0; i<letterList.length;i++) {
        for (int j = 0 ; j< alphabet.length; j++) {
          if(letterList[i] == alphabet[j])
            letterIndexList.add(j);
          letterSelected.add(letterSelected[j]);
        }
      }




    });
  }

  void _startGame(){
    letterList.clear();
    letterIndexList.clear();
    letterSelected.clear();
    solution.clear();
    solutionIndexList.clear();
    board.clear();

    letterList2.clear();


    generateWord();
    if (questionWord != null) {
      createListFromSentences(questionWord);
      createSolution(questionWord);
    }


    startTimer();

  }

  void _resetGame(){
    letterList.clear();
    letterIndexList.clear();
    letterSelected.clear();
    solution.clear();
    solutionIndexList.clear();
    board.clear();

    letterList2.clear();


//    generateWord();
    if (questionWord != null) {
      createListFromSentences(questionWord);
      createSolution(questionWord);
    }


    startTimer();

  }
  void _applyGame(){
    showToastMessages("Your game is applied");

  }

  @override
  void initState() {
    super.initState();
    _startGame();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: doubleTapToQuit,
      child: Scaffold(
        key: scaffoldKey,
//      appBar: AppBar(),
        body: Column(
          children: <Widget>[

            // height: 0.10,
            SizedBox(height: MediaQuery.of(context).size.height * 0.10,),

            // height: 0.20,
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              color: Colors.amber,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Shuffle List"),
                    onPressed: () {
                      _shuffleList();
                    },
                  ),

                  SizedBox(width: 25,),

                  RaisedButton(
                    child: Text("Replay Game"),
                    onPressed: () {
                      _resetGame();
                    },
                  ),

                  SizedBox(width: 25,),

                  RaisedButton(
                    child: Text("New Game"),
                    onPressed: () {
                      _startGame();
                    },
                  ),

                  SizedBox(width: 25,),

                  Text("$_start", style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.normal, color: timerColor),),

                  SizedBox(width: 25,),

                  RaisedButton(
                    child: Text("Apply"),
                    onPressed: () {
                      _applyGame();
                    },
                  ),

                ],
              ),
            ),



            // height: 0.20,
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: letterList2.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: letterList2[index].letterStatus == 0
                        ? Draggable(
                        onDragCompleted: (){
                          setState(() {
                            if (dragCompleted == true) {
                              letterList2[index].letterStatus = 1;
                              dragCompleted = false;
                            }
                          });
                        },
                        data: letterList2[index].alphabetIndex,
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          child: Center(
                            child: Text(
                              letterList2[index].letter,
                              style:
                              TextStyle(color: Colors.white, fontSize: 45.0),
                            ),
                          ),
                          color:
                          letterList2[index].letterStatus == 0
                              ? Colors.pink
                              : Colors.white,
                        ),
                        feedback: Container(
                          width: 30.0,
                          height: 30.0,
                          child: Center(
                            child: Text(
                              letterList2[index].letter,
                              style:
                              TextStyle(color: Colors.white, fontSize: 22.0),
                            ),
                          ),
                          color: Colors.amber,
                        ),
                      )
                        : Container(
                        width: 60.0,
                        height: 60.0,
                        child: Center(
                          child: Text(
                            "",
                            style:
                            TextStyle(color: Colors.white, fontSize: 45.0),
                          ),
                        ),
                        color:Colors.grey,
                      ),
                    );
                  }),
            ),


            // height: 0.30,
            SizedBox(height: MediaQuery.of(context).size.height * 0.30,),

            // height: 0.20,
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: board.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: DragTarget(
                        builder:
                            (context, List<int> candidateData, rejectedData) {


                          return Container(
                            width: 60.0,
                            height: 60.0,
                            child: Center(child: Text(board[index], style: TextStyle(color: Colors.black, fontSize: 45.0),)),
                            color: Colors.amber,
                          );
                        },
                        onWillAccept: (data) {
                          return true;
                        },
                        onAccept: (data) {
                          setState(() {
                            board[index] =alphabet[data];
                            print(data);
//                          letterSelected[data] = 1;
//                        letterList2[2].letterStatus = 1;
                            dragCompleted = true;

                          });

                        },
                      ),
                    );
                  }),
            ),



          ],
        ),
      ),
    );
  }
}



//          SizedBox(height: MediaQuery.of(context).size.height * 0.20,),

//          Container(
//            height: MediaQuery.of(context).size.height * 0.20,
//            child: ListView.builder(
//                scrollDirection: Axis.horizontal,
//                itemCount: solution.length,
//                itemBuilder: (BuildContext context, int index) {
//                  return Padding(
//                    padding: const EdgeInsets.all(2.0),
//                    child: DragTarget(
//                      builder:
//                          (context, List<int> candidateData, rejectedData) {
//                        return Container(
//                          width: 40.0,
//                          height: 60.0,
//                          child: Center(child: Text(solution[index]  + " - " + solutionIndexList[index].toString(), style: TextStyle(color: Colors.black, fontSize: 22.0),)),
//                          color: Colors.amber,
//                        );
//                      },
//                      onWillAccept: (data) {
//                        return true;
//                      },
//                      onAccept: (data) {
//                        if(data == solutionIndexList[index]) {
//                          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Correct!...$data")));
//                        } else {
//                          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Wrong!...$data")));
//                        }
//                      },
//                    ),
//                  );
//                }),
//          )