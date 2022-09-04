import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoLeaguesPage extends StatefulWidget {
  const CupertinoLeaguesPage({Key? key}) : super(key: key);

  @override
  CupertinoLeaguesPageState createState() => CupertinoLeaguesPageState();
}

class CupertinoLeaguesPageState extends State<CupertinoLeaguesPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Leagues'),
      ),
      child: Container(
        //Everything
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 120),

        //alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          //Our Group. Ranking, inter-groups.

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                //Container 0
                alignment: Alignment.topCenter,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: CupertinoTextField(
                  enabled: false,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 5),
                      borderRadius: BorderRadius.circular(20)),
                  textAlign: TextAlign.center,
                  placeholder: 'Leaderboard',
                  placeholderStyle:
                      const TextStyle(color: Colors.white, fontSize: 32),
                  suffix: CupertinoButton(
                      child: const Icon(CupertinoIcons.globe, size: 60),
                      onPressed: () {}),
                )),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
            Container(
              //Container 1
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.lightBlueAccent),
                  //border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: CupertinoTextField(
                            enabled: false,
                            maxLines: 4,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            placeholder: 'Group 1:\nJeffrey\nDaniel\nDiana',
                            placeholderStyle: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            prefix: CupertinoButton(
                              child: const Icon(CupertinoIcons.graph_circle),
                              onPressed: () {},
                            ))),
                    const Expanded(
                        child: CupertinoTextField(
                      enabled: false,
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      placeholder: 'Gain/Loss: \n104%\n20%\n10%',
                      placeholderStyle:
                          TextStyle(color: Colors.white, fontSize: 16),
                    ))
                  ]),
            ),
            Container(
              //Container 2
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.lightBlueAccent),
                  //border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),

              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: CupertinoTextField(
                            enabled: false,
                            maxLines: 4,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            placeholder: 'Group 2:\nLarry\nJeffrey\nAdam',
                            placeholderStyle: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            prefix: CupertinoButton(
                                child: const Icon(CupertinoIcons.graph_circle),
                                onPressed: () {}))),
                    const Expanded(
                        child: CupertinoTextField(
                      enabled: false,
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      placeholder: 'Gain/Loss: \n105%\n104%\n-201%',
                      placeholderStyle:
                          TextStyle(color: Colors.white, fontSize: 16),
                    ))
                  ]),
            ),
            Container(
              //Container 3
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.lightBlueAccent),
                  //border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: CupertinoTextField(
                            enabled: false,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            maxLines: 4,
                            placeholder: 'Group 3:\nKyle\nIan\nSam',
                            placeholderStyle: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            prefix: CupertinoButton(
                              child: const Icon(CupertinoIcons.graph_circle),
                              onPressed: () {},
                            ))),
                    const Expanded(
                        child: CupertinoTextField(
                      enabled: false,
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      placeholder: 'Gain/Loss: \n30%\n25%\n-50%',
                      placeholderStyle:
                          TextStyle(color: Colors.white, fontSize: 16),
                    ))
                  ]),
            ),
            Container(
              //Container 4
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.lightBlueAccent),
                  //border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: CupertinoTextField(
                          enabled: false,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          maxLines: 4,
                          placeholder: 'Group 4:\nNoah\nTyson\nBob',
                          placeholderStyle: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          prefix: CupertinoButton(
                            child: const Icon(CupertinoIcons.graph_circle),
                            onPressed: () {},
                          ))),
                  const Expanded(
                    child: CupertinoTextField(
                      enabled: false,
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      placeholder: 'Gain/Loss: \n-2%\n-74%\n-94%',
                      placeholderStyle:
                          TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
