import 'dart:math';
import 'dart:ui';

import 'constants.dart';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:game2/game.dart';

class OtterManager extends Component with HasGameRef<GameHitOtter> {
  late Timer _timer;
  late List<Component> _otterList;

  // constructor
  OtterManager() {
    _otterList = [];

    // add otter in each 2 second
    _timer = Timer(2, repeat: true, onTick: () {
      // add new otter
      addNewOtter();
    });
  }

  // add new otter to list
  void addNewOtter() {
    final newOtter = Otter();
    gameRef.add(newOtter);
    _otterList.add(newOtter);
  }

  // reset game
  void reset() {
    _timer.stop();
    for (Component i in _otterList) {
      remove(i);
    }
    _otterList.clear();
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
  }
}
