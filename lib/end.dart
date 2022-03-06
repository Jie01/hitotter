import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game2/home.dart';
import 'package:game2/main.dart';

import 'constants.dart';

class End extends StatelessWidget {
  final int mark, round;
  const End({Key? key, required this.mark, required this.round})
      : super(key: key);

  int total() {
    int x = 0;
    for (int e in totalMarks) x = x + e;
    return x;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: const Color(0xffb5e2ff),
          width: (size.height - 60) * screenFactor,
          height: size.height - 60,
          child: Row(
            children: [
              Expanded(
                  child: Image.asset(
                      "assets/images/char/${mark > 0 ? '1' : '2'}.png")),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    (mark > 0 ? "哼 讓你見識到露恰的可愛了吧" : "你看看你 不務正業 騷擾水獺 太壞了吧") +
                        "\n得分: $mark\n目前總得分: ${total()}",
                    style: TextStyle(fontSize: size.width / 29),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                          onPressed: () {
                            AudioManager.instance.stopBgm();
                            totalMarks.clear();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()),
                                (route) => false);
                          },
                          child: const Text("返回主畫面")),
                      round < 6
                          ? FlatButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GHome(round: round + 1)),
                                    (route) => false);
                              },
                              child: Text("第 ${round + 2} 關"))
                          : const SizedBox(),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
