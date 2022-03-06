import 'dart:math';
import 'dart:ui';

import 'constants.dart';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:game2/game.dart';

class OtterManager extends Component with HasGameRef<GameHitOtter> {
  late Random _random;
  late Timer _timer;
  late int spawnLevel;
  late BuildContext _context;
  late List<Component> allotter;

  OtterManager(BuildContext context) {
    _context = context;
    _random = Random();
    spawnLevel = 0;
    allotter = [];
    _timer = Timer(2, repeat: true, onTick: () {
      spawnRanEnemy();
    });
  }

  void spawnRanEnemy() {
    final num = _random.nextInt(enemyType.values.length);

    final type = enemyType.values.elementAt(2);
    final newEnemy = Otter();

    gameRef.add(newEnemy);

    allotter.add(newEnemy);
  }

  void reset() {
    spawnLevel = 0;
    _timer = Timer(1, repeat: true, onTick: () {
      spawnRanEnemy();
    });
    for (Component i in allotter) {
      remove(i);
    }
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void render(Canvas c) {}

  @override
  void update(double t) {
    _timer.update(t);

    // var newSpawnlevel = gameRef.score ~/ 70;
    // if (spawnLevel < newSpawnlevel && spawnLevel < 40) {
    //   spawnLevel = newSpawnlevel;
    //   _timer.stop();
    //
    //   var waittime = (3 / (1 + (0.1 * spawnLevel)));
    //
    //   _timer = Timer(waittime, repeat: true, onTick: () {
    //     spawnRanEnemy();
    //   });
    //   _timer.start();
    // }
  }
}
