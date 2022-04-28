import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _elementList = ["", "", "", "", "", "", "", "", ""];
  bool oTurn = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Tic Tac Toe"),
        actions: [
          new IconButton(
              onPressed: () => restartGame(), icon: new Icon(Icons.refresh))
        ],
      ),
      body: new GridView.builder(
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, index) {
            return new Container(
              margin: EdgeInsets.all(8),
              child: new GestureDetector(
                onTap: () => _onClicked(index),
                child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.green,
                      borderRadius: new BorderRadius.circular(8)),
                  child: new Center(
                    child: new Text(
                      _elementList[index],
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
    );
  }

  void _onClicked(int index) {
    setState(() {
      if (oTurn && _elementList[index] == "") {
        _elementList[index] = "0";
        oTurn = !oTurn;
      } else if (!oTurn && _elementList[index] == "") {
        _elementList[index] = "X";
        oTurn = !oTurn;
      }
    });
  }

  restartGame() {
    setState(() {
      for (int i = 0; i < _elementList.length; i++) _elementList[i] = "";
    });
  }
}
