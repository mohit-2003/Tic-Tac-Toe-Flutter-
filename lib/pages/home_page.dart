import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  bool computerMode = false;
  HomePage({Key? key, required this.computerMode}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _buttonList = new List.filled(9, "", growable: false);
  final _emptyCellsList = new List.filled(9, true, growable: false);
  bool oTurn = false;
  int winnerID = 0;
  bool isGameTied = false;
  late ConfettiController confettiController;
  var player1Name = "Player 1";
  var player2Name = "Player 2";
  String winOrLose = "";

  @override
  void initState() {
    if (widget.computerMode) player2Name = "Computer";
    confettiController =
        new ConfettiController(duration: new Duration(seconds: 1));
    getSharedPreferenceDate();
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: restartGame,
        child: new Icon(Icons.refresh),
        tooltip: "Restart Game",
      ),
      appBar: new AppBar(
        title: new Text("Tic Tac Toe"),
        actions: [
          new IconButton(onPressed: () => {}, icon: new Icon(Icons.settings))
        ],
      ),
      body: new ConfettiWidget(
        confettiController: confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        minBlastForce: 50,
        maxBlastForce: 100,
        numberOfParticles: 200,
        emissionFrequency: 0.05,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Spacer(),
              new Container(
                margin: new EdgeInsets.all(16),
                decoration: new BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: MediaQuery.of(context).platformBrightness !=
                                Brightness.dark
                            ? Colors.black38
                            : Colors.white38)),
                child: new IntrinsicHeight(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        profile1(),
                        new VerticalDivider(
                          thickness: 1,
                          color: MediaQuery.of(context).platformBrightness !=
                                  Brightness.dark
                              ? Colors.black38
                              : Colors.white38,
                        ),
                        profile2()
                      ]),
                ),
              ),
              new Spacer(),
              new GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return new Container(
                      margin: EdgeInsets.all(8),
                      child: new GestureDetector(
                        onTap: () => winnerID == 0 ? _onClicked(index) : null,
                        child: new Container(
                          decoration: new BoxDecoration(
                              color: _buttonList[index] != ""
                                  ? _buttonList[index] == "O"
                                      ? Colors.green
                                      : Colors.deepOrange
                                  : Colors.blueGrey,
                              borderRadius: new BorderRadius.circular(8)),
                          child: new Center(
                            child: new Text(
                              _buttonList[index],
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 60,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              new Padding(
                padding: new EdgeInsets.all(16),
                child: new Text(
                  winOrLose,
                  style:
                      new TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              new Spacer()
            ]),
      ),
    );
  }

  void _onClicked(int index) {
    setState(() {
      if (widget.computerMode)
        vsComputer(index);
      else
        vsFriend(index);
      // checking if anyone wins
      winnerID = checkWinner();
      if (winnerID != 0 && winnerID != -1) confettiController.play();
      // checking if all buttons are filled
      isGameTied = checkGameTied();
      if (isGameTied) winnerID = -1;
      // set text
      switch (winnerID) {
        case -1:
          winOrLose = "Game tied";
          break;
        case 1:
          winOrLose = "$player1Name won";
          break;
        case 2:
          winOrLose = "$player2Name won";
          break;
        default:
          winOrLose = "";
      }
    });
  }

  void vsComputer(int index) {
    // bot play logic
    setState(() {
      _emptyCellsList[index] = false;
      if (_buttonList[index] == "") {
        _buttonList[index] = "O";
      }
    });
    botTurn();
  }

  void vsFriend(int index) {
    setState(() {
      if (oTurn && _buttonList[index] == "") {
        _buttonList[index] = "O";
        oTurn = !oTurn;
      } else if (!oTurn && _buttonList[index] == "") {
        _buttonList[index] = "X";
        oTurn = !oTurn;
      }
    });
  }

  void botTurn() {
    bool isDefendable = false;
    for (int i = 0; i < _emptyCellsList.length; i++) {
      // empty cell
      if (_emptyCellsList[i]) {
        isDefendable = checkRow4Bot(i);
        if (isDefendable) {
          setState(() {
            _buttonList[i] = "X";
            _emptyCellsList[i] = false;
          });
          return;
        }
        isDefendable = checkColumn4Bot(i);
        if (isDefendable) {
          setState(() {
            _buttonList[i] = "X";
            _emptyCellsList[i] = false;
          });
          return;
        }
        isDefendable = checkDiagonal4Bot(i);
        if (isDefendable) {
          setState(() {
            _buttonList[i] = "X";
            _emptyCellsList[i] = false;
          });
          return;
        }
      }
    }
    for (int i = 0; i < _emptyCellsList.length; i++) {
      // empty cell
      if (_emptyCellsList[i]) {
        setState(() {
          _buttonList[i] = "X";
          _emptyCellsList[i] = false;
        });
        return;
      }
    }
  }

  bool checkRow4Bot(int index) {
    if (index >= 0 && index <= 2) {
      int r = 0;
      for (int i = 0; i <= 2; i++) {
        if (index == i) continue;
        if (_buttonList[i] == "O") r++;
      }
      if (r == 2) return true;
    } else if (index >= 3 && index <= 5) {
      int r = 0;
      for (int i = 3; i <= 5; i++) {
        if (index == i) continue;
        if (_buttonList[i] == "O") r++;
      }
      if (r == 2) return true;
    } else if (index >= 6 && index <= 8) {
      int r = 0;
      for (int i = 6; i <= 8; i++) {
        if (index == i) continue;
        if (_buttonList[i] == "O") r++;
      }
      if (r == 2) return true;
    }
    return false;
  }

  bool checkColumn4Bot(int index) {
    if (index == 0 || index == 3 || index == 6) {
      int r = 0;
      for (int i = 0; i <= 6; i += 3) {
        if (index == i) continue;
        if (_buttonList[i] == "O") r++;
      }
      if (r == 2) return true;
    } else if (index == 1 || index == 4 || index == 7) {
      int r = 0;
      for (int i = 1; i <= 7; i += 3) {
        if (index == i) continue;
        if (_buttonList[i] == "O") r++;
      }
      if (r == 2) return true;
    } else if (index == 2 || index == 5 || index == 8) {
      int r = 0;
      for (int i = 2; i <= 8; i += 3) {
        if (index == i) continue;
        if (_buttonList[i] == "O") r++;
      }
      if (r == 2) return true;
    }
    return false;
  }

  bool checkDiagonal4Bot(int index) {
    if (index == 4) {
      bool res = false;
      if (_buttonList[0] == "O" && _buttonList[8] == "O") res = true;
      if (_buttonList[2] == "O" && _buttonList[6] == "O") res = true;
      return res;
    }
    if (index == 0 || index == 8) {
      int r = 0;
      for (int i = 0; i <= 8; i += 4) {
        if (index == i) continue;
        if (_buttonList[i] == "O") r++;
      }
      if (r == 2) return true;
    } else if (index == 2 || index == 6) {
      int r = 0;
      for (int i = 2; i <= 6; i += 2) {
        if (index == i) continue;
        if (_buttonList[i] == "O") r++;
      }
      if (r == 2) return true;
    }
    return false;
  }

  void restartGame() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        _emptyCellsList[i] = true;
      }

      isGameTied = false;
      winnerID = 0;
      oTurn = true;
      for (int i = 0; i < _buttonList.length; i++) _buttonList[i] = "";
    });
  }

  bool checkGameTied() {
    for (var item in _buttonList) if (item == "") return false;

    return true;
  }

  int checkWinner() {
    // winner : 1 for computer or 1st player
    // winner : 2 for 2nd player
    int winner = 0;
    // checking all rows
    if (_buttonList[0] == "O" &&
        _buttonList[1] == "O" &&
        _buttonList[2] == "O") {
      winner = 1;
    } else if (_buttonList[0] == "X" &&
        _buttonList[1] == "X" &&
        _buttonList[2] == "X") {
      winner = 2;
    }
    if (_buttonList[3] == "O" &&
        _buttonList[4] == "O" &&
        _buttonList[5] == "O") {
      winner = 1;
    } else if (_buttonList[3] == "X" &&
        _buttonList[4] == "X" &&
        _buttonList[5] == "X") {
      winner = 2;
    }
    if (_buttonList[6] == "O" &&
        _buttonList[7] == "O" &&
        _buttonList[8] == "O") {
      winner = 1;
    } else if (_buttonList[6] == "X" &&
        _buttonList[7] == "X" &&
        _buttonList[8] == "X") {
      winner = 2;
    }

    // checking all columns
    if (_buttonList[0] == "O" &&
        _buttonList[3] == "O" &&
        _buttonList[6] == "O") {
      winner = 1;
    } else if (_buttonList[0] == "X" &&
        _buttonList[3] == "X" &&
        _buttonList[6] == "X") {
      winner = 2;
    }
    if (_buttonList[1] == "O" &&
        _buttonList[4] == "O" &&
        _buttonList[7] == "O") {
      winner = 1;
    } else if (_buttonList[1] == "X" &&
        _buttonList[4] == "X" &&
        _buttonList[7] == "X") {
      winner = 2;
    }
    if (_buttonList[2] == "O" &&
        _buttonList[5] == "O" &&
        _buttonList[8] == "O") {
      winner = 1;
    } else if (_buttonList[2] == "X" &&
        _buttonList[5] == "X" &&
        _buttonList[8] == "X") {
      winner = 2;
    }

    // checking both diagonal
    if (_buttonList[0] == "O" &&
        _buttonList[4] == "O" &&
        _buttonList[8] == "O") {
      winner = 1;
    } else if (_buttonList[0] == "X" &&
        _buttonList[4] == "X" &&
        _buttonList[8] == "X") {
      winner = 2;
    }
    if (_buttonList[2] == "O" &&
        _buttonList[4] == "O" &&
        _buttonList[6] == "O") {
      winner = 1;
    } else if (_buttonList[2] == "X" &&
        _buttonList[4] == "X" &&
        _buttonList[6] == "X") {
      winner = 2;
    }
    return winner;
  }

  Widget profile1() {
    return new Padding(
      padding: new EdgeInsets.all(16),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new CircleAvatar(
            backgroundColor: oTurn ? Colors.green : Colors.transparent,
            child: new CircleAvatar(
              radius: 16,
              backgroundImage: new AssetImage("assets/images/user1.png"),
              backgroundColor: Colors.orange,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 8),
            child: new Text(
              player1Name,
              style: new TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget profile2() {
    return new Padding(
      padding: new EdgeInsets.all(16),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new CircleAvatar(
            backgroundColor: !oTurn ? Colors.green : Colors.transparent,
            child: new CircleAvatar(
              radius: 16,
              backgroundImage: !widget.computerMode
                  ? new AssetImage("assets/images/user2.png")
                  : new AssetImage("assets/images/computer.png"),
              backgroundColor: Colors.orange,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 8),
            child: new Text(
              player2Name,
              style: new TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  void getSharedPreferenceDate() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      player1Name = pref.getString("player1Name") ?? "Player 1";
      player2Name = pref.getString("player2Name") ?? "Player 2";
    });
  }
}
