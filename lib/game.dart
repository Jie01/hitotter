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

class MyCrate extends SpriteComponent with Tappable, HasGameRef<MyGame> {
  // creates a component that renders the crate.png sprite, with size 16 x 16
  late Size _size;
  late int speed;
  late bool biteyou;
  final Random _random = Random();
  int reverse = 0;
  int upreverse = 0;

  MyCrate(BuildContext context) {
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

    if (x >= 100 && x <= (_size.height - 60) * screenfactor - 140) {
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
      gameRef.score -= 58;
      tapwrong();
    } else if (width <= height * 2.021686747 && !biteyou) {
      gameRef.score += 67;

      origin();
    }
    return super.onTapDown(info);
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}

class MyGame extends FlameGame with HasTappables {
  late EnemyManager _enemyManager;
  late BuildContext _context;

  late TextComponent timetext;
  late TextComponent _scoretext;
  late int score;
  late int _round;

  @override
  void update(double dt) {
    _scoretext.text = score.toString();
    timetext.text = counttime.toString();
    if (counttime == 0) {
      int em = score;
      totalmarks.add(em);
      Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
              builder: (context) => End(
                    mark: em,
                    round: _round,
                  )),
          (route) => false);

      _enemyManager.reset();

      pauseEngine();
      AudioManager.instance.stopBgm();
      score = 0;
    }
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final parallaxComponent = await loadParallaxComponent([
      ParallaxImageData('background.png'),
      // ParallaxImageData('trees.png'),
    ]);
    add(parallaxComponent);
    _enemyManager = EnemyManager(_context);
    add(_enemyManager);
    xyz(_round);

    score = 0;
    _scoretext = TextComponent(
      text: score.toString(),
      textRenderer:
          TextPaint(style: const TextStyle(color: Colors.white, fontSize: 20)),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 10),
    );
    add(_scoretext);

    timetext = TextComponent(
      text: counttime.toString(),
      textRenderer:
          TextPaint(style: const TextStyle(color: Colors.white, fontSize: 20)),
      anchor: Anchor.topCenter,
      position: Vector2(size.x - 60, 10),
    );
    add(timetext);

    AudioManager.instance.startBgm();
  }

  MyGame(BuildContext context, int round) {
    _context = context;
    _round = round;
  }
}
