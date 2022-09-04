import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traderz_app/leagues.dart';
import 'dart:io';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: Colors.lightBlue,
        brightness: Brightness.dark,
      ),
      home: CupertinoLoginPage(),
    );
  }
}

var username = TextEditingController();
var percent = "0";

class CupertinoLoginPage extends StatefulWidget {
  const CupertinoLoginPage({Key? key}) : super(key: key);

  @override
  CupertinoLoginPageState createState() => CupertinoLoginPageState();
}

class CupertinoLoginPageState extends State<CupertinoLoginPage> {
  var password = TextEditingController();
  var client = HttpClient();
  var uri = "http://127.0.0.1:5000";

  Future<HttpClientResponse> makeRequest(Uri uri) async {
    var request = await client.postUrl(uri);
    print(request);
    return await request.close();
  }

  Future getInfo(loginUrl) async {
    var response = await makeRequest(
      Uri.parse(loginUrl),
    );
    if (response.statusCode == 200) {
      print("Success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 120),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Image.asset('assets/blueLogo23.png',
                    width: 300, height: 240)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: CupertinoTextField(
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    border: Border.all(width: 4),
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(10),
                placeholder: 'Username',
                placeholderStyle: const TextStyle(color: Colors.white),
                cursorColor: Colors.lightBlueAccent,
                controller: username,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: CupertinoTextField(
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(10),
                placeholder: 'Password',
                placeholderStyle: const TextStyle(color: Colors.white),
                obscureText: true,
                obscuringCharacter: '*',
                cursorColor: Colors.lightBlueAccent,
                controller: password,
              ),
            ),
            const Divider(),
            const SizedBox(
              width: 10,
              height: 40,
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              color: Colors.lightBlueAccent,
              onPressed: () async {
                await getInfo(
                    "${uri}/users?username=${username.text}&password=${password.text}&login=True");
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CupertinoHomePage(),
                  ),
                );
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              width: 10,
              height: 20,
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CupertinoSignUpPage(),
                  ),
                );
              },
              child:
                  const Text("Sign Up", style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}

class CupertinoHomePage extends StatefulWidget {
  const CupertinoHomePage({Key? key}) : super(key: key);

  @override
  CupertinoHomePageState createState() => CupertinoHomePageState();
}

class CupertinoHomePageState extends State<CupertinoHomePage> {
  bool isPressed = false;
  int cardCount = 0;
  List<Container> cardList = [];
  final postDate = TextEditingController();
  final postCode = TextEditingController();
  final postPrice = TextEditingController();
  final postShares = TextEditingController();
  final postReasoning = TextEditingController();

  var client = HttpClient();
  var client2 = HttpClient();
  var uri = "http://127.0.0.1:5000";

  Future<HttpClientResponse> makeRequest(Uri uri) async {
    var request = await client.putUrl(uri);
    return await request.close();
  }

  Future getInfo(loginUrl) async {
    var response = await makeRequest(
      Uri.parse(loginUrl),
    );
    if (response.statusCode == 200) {
      print("Success");
    }
  }

  Future<HttpClientResponse> makeRequest2(Uri uri) async {
    var request = await client2.getUrl(uri);
    return await request.close();
  }

  Future getInfo2(loginUrl) async {
    var response = await makeRequest2(
      Uri.parse(loginUrl),
    );
    if (response.statusCode == 200) {
      print("Success");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    var popDialog = isPressed
        ? Stack(
            children: [
              Align(
                child: Container(
                  width: width,
                  height: height,
                  color: Colors.black.withOpacity(0.65),
                ),
              ),
              Align(
                // ignore: sized_box_for_whitespace
                child: Container(
                  width: 350,
                  height: 430,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Colors.white,
                    child: SizedBox(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(25),
                            child: const Text(
                              "Post",
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(3),
                          ),

                          // ignore: sized_box_for_whitespace
                          Container(
                            width: 300,
                            height: 40,
                            child: CupertinoTextField(
                              placeholder: "Date",
                              placeholderStyle:
                                  const TextStyle(color: Colors.white60),
                              controller: postDate,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(3),
                          ),
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: 300,
                            height: 40,
                            child: CupertinoTextField(
                              autofocus: true,
                              placeholder: "Ticker Symbol",
                              placeholderStyle:
                                  const TextStyle(color: Colors.white60),
                              controller: postCode,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(3),
                          ),
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: 300,
                            height: 40,
                            child: CupertinoTextField(
                              placeholder: "Stock Price per Share",
                              placeholderStyle:
                                  const TextStyle(color: Colors.white60),
                              controller: postPrice,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(3),
                          ),
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: 300,
                            height: 40,
                            child: CupertinoTextField(
                              placeholder: "Shares Bought",
                              placeholderStyle:
                                  const TextStyle(color: Colors.white60),
                              controller: postShares,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(3),
                          ),
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: 300,
                            height: 40,
                            child: CupertinoTextField(
                              placeholder: "Reasoning",
                              placeholderStyle:
                                  const TextStyle(color: Colors.white60),
                              controller: postReasoning,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          CupertinoButton.filled(
                            onPressed: () async {
                              await getInfo(
                                  "${uri}/users?username=${username.text}&date=${postDate.text}&ticker=${postCode.text}&cost=${postPrice.text}&shares=${postShares.text}");
                              percent = "-11.34%";
                              setState(
                                () {
                                  isPressed = false;
                                  cardList.insert(
                                    cardCount,
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        border: Border.all(
                                            width: 10, color: Colors.black),
                                      ),
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              // ignore: avoid_unnecessary_containers
                                              Container(
                                                child: Text(
                                                  postCode.text,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              // ignore: avoid_unnecessary_containers
                                              Container(
                                                child: Text(
                                                  postDate.text,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, bottom: 25.0),
                                                child: Text(
                                                  "\$ ${postPrice.text} per share; ",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, bottom: 25.0),
                                                child: Text(
                                                  "${postShares.text} shares",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // ignore: avoid_unnecessary_containers
                                          Container(
                                            child: Text(
                                              postReasoning.text,
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  cardCount++;
                                  setState(() {
                                    postDate.text = "";
                                    postCode.text = "";
                                    postPrice.text = "";
                                    postShares.text = "";
                                    postReasoning.text = "";
                                  });
                                },
                              );
                            },
                            child: const Text(
                              'Enter',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();

    return Stack(
      children: [
        CupertinoPageScaffold(
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              currentIndex: 0,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.game_controller),
                  label: 'Leagues',
                ),
              ],
            ),
            tabBuilder: (context, index) {
              late final CupertinoTabView returnValue;
              switch (index) {
                case 0:
                  returnValue = CupertinoTabView(
                    builder: (context) {
                      return CustomScrollView(
                        slivers: [
                          CupertinoSliverNavigationBar(
                            backgroundColor: Colors.black,
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(
                                "${percent}%",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue,
                                ),
                              ),
                            ),
                            trailing: GestureDetector(
                              child: const Icon(CupertinoIcons.add),
                              onTap: () {
                                setState(
                                  () {
                                    isPressed = true;
                                  },
                                );
                              },
                            ),
                            largeTitle: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "Shared.",
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(cardList),
                          ),
                        ],
                      );
                    },
                  );
                  break;
                case 1:
                  returnValue = CupertinoTabView(
                    builder: (context) {
                      return const CupertinoLeaguesPage();
                    },
                  );
                  break;
              }
              return returnValue;
            },
          ),
        ),
        Align(
          // ignore: sort_child_properties_last
          child: popDialog,
          alignment: FractionalOffset.center,
        ),
      ],
    );
  }
}

class CupertinoSignUpPage extends StatefulWidget {
  const CupertinoSignUpPage({Key? key}) : super(key: key);

  @override
  CupertinoSignUpState createState() => CupertinoSignUpState();
}

class CupertinoSignUpState extends State<CupertinoSignUpPage> {
  var password = TextEditingController();
  var client = HttpClient();
  var uri = "http://127.0.0.1:5000";

  Future<HttpClientResponse> makeRequest(Uri uri) async {
    var request = await client.postUrl(uri);
    print(request);
    return await request.close();
  }

  Future getInfo(loginUrl) async {
    var response = await makeRequest(
      Uri.parse(loginUrl),
    );
    if (response.statusCode == 200) {
      print("Success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child:
                  Image.asset('assets/blueLogo23.png', width: 300, height: 240),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CupertinoTextField(
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    border: Border.all(width: 4),
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(10),
                placeholder: 'First Name',
                placeholderStyle: const TextStyle(color: Colors.white),
                cursorColor: Colors.lightBlueAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CupertinoTextField(
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    border: Border.all(width: 4),
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(10),
                placeholder: 'Last Name',
                placeholderStyle: const TextStyle(color: Colors.white),
                cursorColor: Colors.lightBlueAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CupertinoTextField(
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    border: Border.all(width: 4),
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(10),
                placeholder: 'Email',
                placeholderStyle: const TextStyle(color: Colors.white),
                cursorColor: Colors.lightBlueAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CupertinoTextField(
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    border: Border.all(width: 4),
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(10),
                placeholder: 'Username',
                placeholderStyle: const TextStyle(color: Colors.white),
                cursorColor: Colors.lightBlueAccent,
                controller: username,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CupertinoTextField(
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    border: Border.all(width: 4),
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(10),
                placeholder: 'Password',
                placeholderStyle: const TextStyle(color: Colors.white),
                obscureText: true,
                obscuringCharacter: '*',
                cursorColor: Colors.lightBlueAccent,
                controller: password,
              ),
            ),
            const Divider(),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CupertinoLoginPage(),
                      ),
                    );
                  },
                  child: const Icon(CupertinoIcons.arrow_turn_up_left),
                ),
                CupertinoButton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    await getInfo(
                        "${uri}/users?username=${username.text}&password=${password.text}");
                    if (!mounted) return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CupertinoHomePage(),
                        ));
                  },
                  child: const Text("Sign Up",
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
