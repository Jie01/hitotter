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

// horizon direction
enum EHDirect {
  ED_Left,
  ED_Right,
}

// veridical direction
enum EVDirect {
  ED_Up,
  ED_Down,
}

class Otter extends SpriteComponent with Tappable, HasGameRef<GameHitOtter> {
  // creates a component that renders the crate.png sprite, with size 16 x 16
  late int speed;
  final Random _random = Random();

  EHDirect xDirection = EHDirect.ED_Left;
  EVDirect yDirection = EVDirect.ED_Down;

  // the size factor between game size and otter size
  final double _sizeFactor = 0.06;

  late Rect _swimRange;

  String spritSrc = 'char/lutra0.png';

  bool biteYou = false;
  int signIndex = -1;

  // constructor
  Otter() {}

  Future<void> onLoad() async {
    sprite = await Sprite.load(spritSrc);
    anchor = Anchor.center;
    reset();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // We don't need to set the position in the constructor, we can set it directly here since it will
    // be called once before the first time it is rendered.

    // wait 4 ~ 12S
    int waitSecond = 4 + _random.nextInt(12 - 4);
    Future.delayed(Duration(seconds: waitSecond), () async {
      signIndex = _random.nextInt(5);
    });
    Future.delayed(Duration(seconds: waitSecond + 2), reset);

    setTimer(1, (timer) {
      _shuffleDir();
    });

    // init spawn position
    x = (gameSize.x / (_random.nextInt(6) + 2));
    y = (gameSize.y / (_random.nextInt(9) * 0.1 + 1.1));

    // random direction
    _shuffleDir();

    // random speed
    speed = 100 + _random.nextInt(160 - 100);

    // calculate height
    height = gameSize.x * _sizeFactor;

    // calculate swim range
    _swimRange =
        Offset(0, gameSize.y * 0.2) & Size(gameSize.x, gameSize.y * 0.8);

    // update picture
    _updatePic();
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    // update position
    var xDirectionFactor = (xDirection == EHDirect.ED_Right) ? 1 : -1;
    var yDirectionFactor = (yDirection == EVDirect.ED_Down) ? 1 : -1;
    x += speed * dt * xDirectionFactor;
    y += speed / 2 * dt * yDirectionFactor;

    // x dir bump detect
    if (((x - width / 2) < _swimRange.left && xDirection == EHDirect.ED_Left) ||
        ((x + width / 2) > _swimRange.right &&
            xDirection == EHDirect.ED_Right)) {
      xDirection = (xDirection == EHDirect.ED_Left
          ? EHDirect.ED_Right
          : EHDirect.ED_Left);
    }

    // y dir bump detect
    if (((y - height / 2) < _swimRange.top && yDirection == EVDirect.ED_Up) ||
        ((y + height / 2) > _swimRange.bottom &&
            yDirection == EVDirect.ED_Down)) {
      yDirection =
          (yDirection == EVDirect.ED_Up ? EVDirect.ED_Down : EVDirect.ED_Up);
    }

    // update picture
    _updatePic();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if (signIndex == -1) {
      gameRef._score -= 58;
      _tapWrong();
    } else if (biteYou == false) {
      gameRef._score += 67;
      signIndex = -1;
    }
    return super.onTapDown(info);
  }

  @override
  void onRemove() {
    super.onRemove();
  }

  // reset
  Future<void> reset() async {
    biteYou = false;
    signIndex = -1;
  }

  Future<void> _tapWrong() async {
    biteYou = true;
    // keep bite status, duration: 2s
    Future.delayed(const Duration(seconds: 2), reset);
  }

  // shuffle direction
  void _shuffleDir() {
    int randVarH = _random.nextInt(100);
    int randVarV = _random.nextInt(100);

    xDirection = (randVarH % 2 == 0) ? EHDirect.ED_Left : EHDirect.ED_Right;
    yDirection = (randVarV % 2 == 0) ? EVDirect.ED_Down : EVDirect.ED_Up;
  }

  // update picture
  Future<void> _updatePic() async {
    if (biteYou == true) {
      _loadSprite('char/bite.png');
    } else if (signIndex != -1) {
      _loadSprite('char/sign$signIndex.png');
    } else if (xDirection == EHDirect.ED_Left) {
      _loadSprite('char/lutra0.png');
    } else {
      _loadSprite('char/lutra1.png');
    }
  }

  // load sprite
  void _loadSprite(String src) async {
    // if path is same, don't need to change picture
    if (spritSrc != src) {
      sprite = await Sprite.load(src);
      width = height * (sprite!.image.width / sprite!.image.height);
      spritSrc = src;
    }
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
    final backgroundComponent = await loadParallaxComponent([
      ParallaxImageData('background.png'),
    ]);
    add(backgroundComponent);

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
