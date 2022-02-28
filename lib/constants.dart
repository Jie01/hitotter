import 'dart:async';

import 'package:just_audio/just_audio.dart';

enum enemyType { father, fish, you }

const double screenfactor = 1.777777;

const int limittime = 20;

int counttime = limittime;

const String rule = """這裡有一堆披著水獺皮的露軍, 會不定時舉牌
要在舉牌的時候點擊去淨化他們
不然他們會感染成內心抖M不冷靜 外表正常的水獺
點錯會讓水獺生氣 咬你""";

void xyz(int round) {
  counttime = limittime + round * 10;
  Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    if (counttime > 0) {
      counttime = (limittime + round * 10) - timer.tick;
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

  Future<void> init() async {
    await player.setAsset('assets/audios/bgm.mp3');
    await player.setLoopMode(LoopMode.all);
  }

  void startBgm() {
    player.seek(const Duration(seconds: 0));
    player.play();
  }

  void pauseBgm() {
    player.pause();
  }

  void stopBgm() {
    player.stop();
  }
}
