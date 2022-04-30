import 'package:flutter/material.dart';
import 'package:tic_tac_toe/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({Key? key}) : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  var player1Name = "";
  var player2Name = "";
  late TextEditingController textFieldController1;
  late TextEditingController textFieldController2;
  @override
  void initState() {
    getSharedPreferenceDate();
    textFieldController1 = new TextEditingController(text: player1Name);
    textFieldController2 = new TextEditingController(text: player2Name);
    super.initState();
  }

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
                title: new Text("Computer"),
                subtitle: new Text("Offline"),
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => new Container(
                            margin: new EdgeInsets.all(16),
                            child: new Padding(
                              padding: new EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  new TextField(
                                    controller: textFieldController1,
                                    decoration: new InputDecoration(
                                        border: new OutlineInputBorder(),
                                        labelText: "Enter Your Name",
                                        icon: new CircleAvatar(
                                          child: new Image.asset(
                                              "assets/images/user2.png"),
                                        )),
                                  ),
                                  new SizedBox(
                                    height: 20,
                                    width: 20,
                                  ),
                                  new OutlinedButton(
                                      onPressed: () {
                                        saveDetails("player1Name",
                                            textFieldController1.text);
                                        saveDetails("player2Name", "Computer");
                                        navigate(true, context);
                                      },
                                      child: new Text("Submit"))
                                ],
                              ),
                            ),
                          ));
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
                title: new Text("Friend"),
                subtitle: new Text("Offline"),
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => new Container(
                            margin: new EdgeInsets.all(16),
                            child: new Padding(
                              padding: new EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  new TextField(
                                    controller: textFieldController1,
                                    decoration: new InputDecoration(
                                        border: new OutlineInputBorder(),
                                        labelText: "Enter Player 1 Name",
                                        icon: new CircleAvatar(
                                          child: new Image.asset(
                                              "assets/images/user1.png"),
                                        )),
                                  ),
                                  new SizedBox(
                                    height: 20,
                                    width: 20,
                                  ),
                                  new TextField(
                                    controller: textFieldController2,
                                    decoration: new InputDecoration(
                                        border: new OutlineInputBorder(),
                                        labelText: "Enter Player 2 Name",
                                        icon: new CircleAvatar(
                                          child: new Image.asset(
                                              "assets/images/user2.png"),
                                        )),
                                  ),
                                  new SizedBox(
                                    height: 20,
                                    width: 20,
                                  ),
                                  new OutlinedButton(
                                      onPressed: () {
                                        saveDetails("player1Name",
                                            textFieldController1.text);
                                        saveDetails("player2Name",
                                            textFieldController2.text);
                                        navigate(false, context);
                                      },
                                      child: new Text("Submit"))
                                ],
                              ),
                            ),
                          ));
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
                title: new Text("Friend"),
                subtitle: new Text("Online"),
                onTap: () {},
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

  void navigate(bool computerMode, BuildContext context) {
    if (Navigator.canPop(context)) Navigator.pop(context);

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new HomePage(computerMode: computerMode)));
  }

  void saveDetails(String key, String value) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  void getSharedPreferenceDate() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      player1Name = pref.getString("player1Name") ?? "";
      player2Name = pref.getString("player2Name") ?? "";
    });
  }
}
