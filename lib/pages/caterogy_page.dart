import 'package:flutter/material.dart';
import 'package:tic_tac_toe/pages/home_page.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new ListView(
          shrinkWrap: true,
          children: [
            new Padding(
              padding: new EdgeInsets.all(8),
              child: new ListTile(
                leading: new CircleAvatar(
                  backgroundImage: new AssetImage("assets/images/computer.png"),
                ),
                title: new Text("VS Computer"),
                subtitle: new Text("Offline"),
                onTap: () {
                  onClick(0, context);
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: new BorderSide(color: Colors.blueGrey)),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(8),
              child: new ListTile(
                leading: new CircleAvatar(
                  backgroundImage: new AssetImage("assets/images/user2.png"),
                ),
                title: new Text("VS Friend"),
                subtitle: new Text("Offline"),
                onTap: () {
                  onClick(1, context);
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: new BorderSide(color: Colors.blueGrey)),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(8),
              child: new ListTile(
                leading: new CircleAvatar(
                  backgroundImage: new AssetImage("assets/images/user1.png"),
                ),
                title: new Text("VS Friend"),
                subtitle: new Text("Online"),
                onTap: () {
                  onClick(2, context);
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: new BorderSide(color: Colors.blueGrey)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onClick(int index, BuildContext context) {
    switch (index) {
      case 0:
        break;
      default:
    }
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new HomePage()));
  }
}
