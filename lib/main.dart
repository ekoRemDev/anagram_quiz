import 'dart:math';

import 'package:flutter/material.dart';

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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  var alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];

  List<String> wordList = ["DOMATES","PATATES","KARPUZ","KAVUN","PEYNIR","SOGUKSU","BALIK","BUZ","BARDAK","RAKI"];

  String questionWord = "";

  List<String> letterList = [];
  List<int> letterIndexList = [];
  List<String> solution = [];
  List<int> solutionIndexList = [];
  List<String> board = [];

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
          solutionIndexList.add(j);
      }
    }


    for (int i=0; i<letterList.length;i++) {
      board.add("*");
    }

    print("----index list is-----");
    print(letterIndexList);

    _shuffleList();
  }

  void createSolution(String word) {
    solution = word.split("").toList();
    print("This is solution");
    print(solution);
  }

  void _shuffleList() {
    setState(() {
      letterList.shuffle();

      letterIndexList.clear();

      for (int i=0; i<letterList.length;i++) {
        for (int j = 0 ; j< alphabet.length; j++) {
          if(letterList[i] == alphabet[j])
            letterIndexList.add(j);
        }
      }


    });
  }

  void _resetGame(){
    letterList.clear();
    letterIndexList.clear();
    solution.clear();
    solutionIndexList.clear();
    board.clear();

    generateWord();
    if (questionWord != null) {
      createListFromSentences(questionWord);
      createSolution(questionWord);
    }

  }

  @override
  void initState() {
    super.initState();
    _resetGame();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                SizedBox(width: 15,),

                RaisedButton(
                  child: Text("ReStart Game"),
                  onPressed: () {
                    _resetGame();
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
                itemCount: letterList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Draggable(
                      data: letterIndexList[index],
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        child: Center(
                          child: Text(
                            letterList[index],
                            style:
                            TextStyle(color: Colors.white, fontSize: 45.0),
                          ),
                        ),
                        color: Colors.pink,
                      ),
                      feedback: Container(
                        width: 30.0,
                        height: 30.0,
                        child: Center(
                          child: Text(
                            letterList[index],
                            style:
                            TextStyle(color: Colors.white, fontSize: 22.0),
                          ),
                        ),
                        color: Colors.amber,
                      ),
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
                        });

                      },
                    ),
                  );
                }),
          ),



        ],
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