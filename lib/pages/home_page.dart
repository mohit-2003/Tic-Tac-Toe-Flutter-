import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _buttonList = new List.filled(9, "", growable: false);
  bool oTurn = true;
  int winnerID = 0;
  bool isGameTied = false;
  late ConfettiController confettiController;

  @override
  void initState() {
    confettiController =
        new ConfettiController(duration: new Duration(seconds: 3));
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
                    border: Border.all(color: Colors.black38)),
                child: new IntrinsicHeight(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        profile1(),
                        new VerticalDivider(
                          thickness: 1,
                          color: Colors.black38,
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
                  winnerID != 0
                      ? winnerID == 1
                          ? "Player 1 won"
                          : "Player 2 won"
                      : "",
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
      if (oTurn && _buttonList[index] == "") {
        _buttonList[index] = "O";
        oTurn = !oTurn;
      } else if (!oTurn && _buttonList[index] == "") {
        _buttonList[index] = "X";
        oTurn = !oTurn;
      }
      // checking if anyone wins
      winnerID = checkWinner();
      if (winnerID != 0) confettiController.play();
      // checking if all buttons are filled
      isGameTied = checkGameTied();
      if (isGameTied) restartGame();
    });
  }

  void restartGame() {
    setState(() {
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
              "Player 1",
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
              backgroundImage: new AssetImage("assets/images/user2.png"),
              backgroundColor: Colors.orange,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 8),
            child: new Text(
              "Player 2",
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
}
