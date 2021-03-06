import 'dart:math';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

List images = [
  "lutra0",
  "lutra1",
  ...List.generate(12, (index) => "sign$index"),
  "1",
  "2",
  "3",
  "bite",
];

enum enemyType { father, fish, you }

List<int> totalMarks = [];

const TextStyle mediumstyle = TextStyle(fontSize: 24);

const TextStyle gametext =
    TextStyle(color: Colors.white, fontSize: 20, fontFamily: "regular");

const double screenFactor = 1.777777;

const int limitTime = 20;

int maxRound = 7;

int maxOtter = 30;

double volume = 100;

double speedFactor = 1.0;

int remainTime = limitTime;

bool wasHitOtter = false;

const String rule = """這裡有一堆披著水獺皮的露軍, 會不定時舉牌
要在舉牌的時候點擊去淨化他們
不然他們會感染成內心抖M不冷靜 外表正常的水獺
點錯會讓水獺生氣 咬你""";

void setGlobalTimer() {
  setTimer(1, (Timer timer) {
    if (remainTime > 0) {
      remainTime--;
    } else {
      timer.cancel();
    }
  });
}

class AudioManager {
  AudioManager._internal();

  static final AudioManager _instance = AudioManager._internal();

  static AudioManager get instance => _instance;

  final player = AudioPlayer();
  final signplayer = AudioPlayer();

  Future<void> init() async {
    await player.setAsset('assets/audios/bgm.mp3');
    await player.setLoopMode(LoopMode.all);
  }

  Future<void> onhitsign(String i) async {
    await signplayer.setAsset('assets/audios/$i.wav');
    await signplayer.setLoopMode(LoopMode.off);
    await signplayer.play();
  }

  void startBgm() {
    player.setVolume(volume.toInt() * 0.01);
    player.seek(const Duration(seconds: 0));
    player.play();
  }

  void pauseBgm() {
    player.pause();
  }

  void stopBgm() {
    player.stop();
    signplayer.stop();
  }
}

// set timer, unit: second
void setTimer(int second, Function(Timer) callBack) =>
    Timer.periodic(Duration(seconds: second), callBack);

class Utility {
  static final Random _random = Random();

  // get rand number from lowerLimit to upperLimit( include )
  static int getRandRangeInt(int lowerLimit, int upperLimit) {
    return lowerLimit + _random.nextInt(upperLimit - lowerLimit);
  }

  // get rand number from lowerLimit to upperLimit( include )
  static double getRandRangeDouble(double lowerLimit, double upperLimit) {
    return lowerLimit + _random.nextDouble() * (upperLimit - lowerLimit);
  }
}
