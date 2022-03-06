import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:game2/constants.dart';
import 'package:game2/end.dart';
import 'package:game2/enemyManager.dart';

class Otter extends SpriteComponent with Tappable, HasGameRef<GameHitOtter> {
  // creates a component that renders the crate.png sprite, with size 16 x 16
  late Size _size;
  late int speed;
  late bool biteyou;
  final Random _random = Random();
  int reverse = 0;
  int upreverse = 0;

  Otter(BuildContext context) {
    _size = MediaQuery.of(context).size;
    biteyou = false;
  }

  Future<void> onLoad() async {
    sprite = await Sprite.load('char/lutra0.png');

    anchor = Anchor.center;
  }

  Future<void> origin() async {
    width = height * 2.021686747;
    sprite = await Sprite.load('char/lutra${reverse % 2 == 0 ? '0' : '1'}.png');
    biteyou = false;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // We don't need to set the position in the constructor, we can set it directly here since it will
    // be called once before the first time it is rendered.

    // wait 4 ~ 12S
    int waitsecond = 4 + _random.nextInt(12 - 4);
    Future.delayed(Duration(seconds: waitsecond), () async {
      sprite = await Sprite.load('char/sign${_random.nextInt(5)}.png');
      width = height * 1.16216216;
    });
    Future.delayed(Duration(seconds: waitsecond + 2), origin);

    ktimer(1, (timer) {
      upreverse = _random.nextInt(5);
    });

    x = (gameSize.x / (_random.nextInt(6) + 2));
    y = (gameSize.y / (_random.nextInt(9) * 0.1 + 1.1));
    speed = 100 + _random.nextInt(160 - 100);
    height = gameSize.x / 15.48;
    width = height * 2.021686747;
  }

  Future<void> turnback() async {
    reverse = reverse + 1;

    if (reverse % 2 == 0) {
      x -= 20;
      sprite = await Sprite.load('char/lutra0.png');
    } else {
      x += 20;
      sprite = await Sprite.load('char/lutra1.png');
    }
    width = height * 2.021686747;
  }

  @override
  Future<void> update(double t) async {
    super.update(t);

    if (x >= 100 && x <= (_size.height - 60) * screenFactor - 140) {
      if (reverse % 2 == 0) {
        x -= speed * t;
      } else {
        x += speed * t;
        // print(x);
      }
      if (upreverse == 0 && y > (_size.height - 60) / 3) {
        y -= speed / 2 * t;
      } else if (upreverse == 1 && y < _size.height - 120) {
        y += speed / 2 * t;
      }
    } else {
      turnback();
      // print(reverse);
    }
  }

  Future<void> tapwrong() async {
    sprite = await Sprite.load('char/bite.png');
    width = height * 1.16216216;
    biteyou = true;
    Future.delayed(const Duration(milliseconds: 2000), origin);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if (width >= height * 2.021686747) {
      gameRef._score -= 58;
      tapwrong();
    } else if (width <= height * 2.021686747 && !biteyou) {
      gameRef._score += 67;

      origin();
    }
    return super.onTapDown(info);
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}

class GameHitOtter extends FlameGame with HasTappables {
  //
  late BuildContext _context;

  // otter manager
  late OtterManager _otterManager;

  // game text component
  late TextComponent _remainTimeText;

  // score text
  late TextComponent _scoreText;

  // game score
  int _score = 0;

  // game round
  late int _round;

  // constructor
  GameHitOtter(BuildContext context, int round) {
    _context = context;
    _round = round;

    _otterManager = OtterManager(_context);

    // init text component style
    _remainTimeText = TextComponent(
        textRenderer: TextPaint(
            style: const TextStyle(color: Colors.white, fontSize: 20)),
        anchor: Anchor.topCenter);

    _scoreText = TextComponent(
        textRenderer: TextPaint(
            style: const TextStyle(color: Colors.white, fontSize: 20)),
        anchor: Anchor.topCenter);
  }

  @override
  void update(double dt) {
    // update component
    _updateViewComponent();

    // check game is finish or not
    if (remainTime <= 0) {
      totalMarks.add(_score);
      Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
              builder: (context) => End(
                    mark: _score,
                    round: _round,
                  )),
          (route) => false);

      _otterManager.reset();

      pauseEngine();
      AudioManager.instance.stopBgm();
    }

    super.update(dt);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    _updateViewComponent();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // set background
    final parallaxComponent = await loadParallaxComponent([
      ParallaxImageData('background.png'),
    ]);
    add(parallaxComponent);

    // init enemy manager
    add(_otterManager);

    // reset score
    _score = 0;

    // set timer
    remainTime = limitTime + _round * 10;
    setGlobalTimer();

    // add text component
    add(_scoreText);
    add(_remainTimeText);

    // start BGM
    AudioManager.instance.startBgm();
  }

  // update view component
  void _updateViewComponent() {
    _remainTimeText.text = '剩餘時間: ' + remainTime.toString() + '秒';
    _remainTimeText.position =
        Vector2(size.x - _remainTimeText.width, _remainTimeText.height / 2);

    _scoreText.text = _score.toString() + '分';
    _scoreText.position = Vector2(size.x / 2, _scoreText.height / 2);
  }
}
