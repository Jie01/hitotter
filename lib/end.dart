import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game2/home.dart';
import 'package:game2/main.dart';

import 'constants.dart';

class End extends StatelessWidget {
  final int mark, round;
  const End({Key? key, required this.mark, required this.round})
      : super(key: key);

  int totalScore() {
    int scoreSum = 0;
    for (int score in totalMarks) scoreSum = scoreSum + score;
    return scoreSum;
  }

  String get endText {
    String ret = '';

    if (mark > 0) {
      ret += "哼 讓你見識到露恰的可愛了吧\n";
    } else if (wasHitOtter) {
      ret += "你看看你 不務正業 騷擾水獺\n太壞了吧\n";
    } else {
      ret += "一隻水獺都摸不到 好可憐歐\n";
    }

    ret += "得分: $mark\n";
    ret += "目前總得分: ${totalScore()}";

    return ret;
  }

  Image get endImage {
    if (mark > 0) {
      return Image.asset("images/char/1.png");
    } else if (wasHitOtter) {
      return Image.asset("images/char/2.png");
    } else {
      return Image.asset("images/char/3.png");
    }
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
              Expanded(child: endImage),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    endText,
                    style: TextStyle(fontSize: size.width / 35),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                          onPressed: () {
                            AudioManager.instance.stopBgm();
                            totalMarks.clear();
                            if (round == maxRound && totalScore() == 520)
                              AudioManager.instance.onhitsign("end");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()),
                                (route) => false);
                          },
                          child: const Text("返回主畫面")),
                      round < maxRound
                          ? FlatButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GHome(round: round + 1)),
                                    (route) => false);
                              },
                              child: Text("下一關(${round + 1}/$maxRound)"))
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
