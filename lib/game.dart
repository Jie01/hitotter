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

enum EOtterState { EOS_Normal, EOS_Sign, EOS_BiteYou }

class Otter extends SpriteComponent with Tappable, HasGameRef<GameHitOtter> {
  // the size factor between game size and otter size
  final double _sizeFactor = 0.06;

  // direction
  EHDirect xDirection = EHDirect.ED_Left;
  EVDirect yDirection = EVDirect.ED_Down;

  // speed
  late Vector2 _speed;

  // otter swim range
  late Rect _swimRange;

  // sprit picture source
  String spritSrc = 'char/lutra0.png';

  // sign picture index
  int _signIndex = 0;

  // otter state
  EOtterState _state = EOtterState.EOS_Normal;

  // constructor
  Otter() {
    _speed = Vector2(0.0, 0.0);
  }

  @override
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
    int waitSecond = Utility.getRandRangeInt(4, 12);
    Future.delayed(Duration(seconds: waitSecond), () async {
      _signIndex = Utility.getRandRangeInt(0, 12);
      _state = EOtterState.EOS_Sign;
    });
    Future.delayed(Duration(seconds: waitSecond + 2), reset);

    // set shuffle dir time
    int shuffleTime = Utility.getRandRangeInt(1, 3);
    setTimer(shuffleTime, (timer) {
      _shuffleDir();
    });

    // init spawn position
    x = gameSize.x * Utility.getRandRangeDouble(0.2, 0.8);
    y = gameSize.y * Utility.getRandRangeDouble(0.2, 0.8);

    // random direction
    _shuffleDir();

    // random speed
    _speed.x = Utility.getRandRangeInt(100, 160) * speedFactor;
    _speed.y = Utility.getRandRangeInt(100, 160) * speedFactor;

    // calculate height
    height = gameSize.x * _sizeFactor;

    // calculate swim range
    _swimRange =
        Offset(20, gameSize.y * 0.2) & Size(gameSize.x - 20, gameSize.y * 0.8);

    // update picture
    _updatePic();
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    // update position
    var xDirectionFactor = (xDirection == EHDirect.ED_Right) ? 1 : -1;
    var yDirectionFactor = (yDirection == EVDirect.ED_Down) ? 1 : -1;
    x += _speed.x * dt * xDirectionFactor;
    y += _speed.y * dt * yDirectionFactor;

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
    if (_state == EOtterState.EOS_Normal) {
      gameRef._score -= 58;
      AudioManager.instance.onhitsign("bite");
      _tapWrong();
    } else if (_state == EOtterState.EOS_Sign) {
      gameRef._score += 67;
      AudioManager.instance.onhitsign("$_signIndex");
      reset();
    }

    wasHitOtter = true;
    return super.onTapDown(info);
  }

  @override
  void onRemove() {
    super.onRemove();
  }

  // reset
  Future<void> reset() async {
    _state = EOtterState.EOS_Normal;
  }

  // tap wrong otter
  Future<void> _tapWrong() async {
    _state = EOtterState.EOS_BiteYou;
    // keep bite status, duration: 2s
    Future.delayed(const Duration(seconds: 2), reset);
  }

  // shuffle direction
  void _shuffleDir() {
    int randVarH = Utility.getRandRangeInt(0, 100);
    int randVarV = Utility.getRandRangeInt(0, 100);

    xDirection = (randVarH % 2 == 0) ? EHDirect.ED_Left : EHDirect.ED_Right;
    yDirection = (randVarV % 2 == 0) ? EVDirect.ED_Down : EVDirect.ED_Up;
  }

  // update picture
  Future<void> _updatePic() async {
    switch (_state) {
      case EOtterState.EOS_Normal:
        if (xDirection == EHDirect.ED_Left) {
          _loadSprite('char/lutra0.png');
        } else {
          _loadSprite('char/lutra1.png');
        }
        break;
      case EOtterState.EOS_Sign:
        _loadSprite('char/sign$_signIndex.png');
        break;
      case EOtterState.EOS_BiteYou:
        _loadSprite('char/bite.png');
        break;
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
  // game main context
  late BuildContext _gameMainContext;

  // otter manager
  late OtterManager _otterManager;

  // game text component
  late TextComponent _remainTimeText;

  // score text
  late TextComponent _scoreText;

  // round text
  late TextComponent _roundText;

  // game score
  int _score = 0;

  // game round
  late int _round;

  // constructor
  GameHitOtter(BuildContext context, int round) {
    wasHitOtter = false;

    _gameMainContext = context;
    _round = round;

    _otterManager = OtterManager();

    // init text component style
    _remainTimeText = TextComponent(
        textRenderer: TextPaint(style: gametext), anchor: Anchor.topCenter);

    _scoreText = TextComponent(
        textRenderer: TextPaint(style: gametext), anchor: Anchor.topCenter);

    _roundText = TextComponent(
        textRenderer: TextPaint(style: gametext), anchor: Anchor.topCenter);
  }

  @override
  void update(double dt) {
    // update component
    _updateViewComponent();

    // check game is finish or not
    if (remainTime <= 0) {
      totalMarks.add(_score);
      Navigator.pushAndRemoveUntil(
          _gameMainContext,
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
    remainTime = limitTime + (_round - 1) * 10;
    setGlobalTimer();

    // add text component
    add(_scoreText);
    add(_remainTimeText);
    add(_roundText);

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

    _roundText.text = '關卡: ' + _round.toString() + '/' + maxRound.toString();
    _roundText.position = Vector2(50, _scoreText.height / 2);
  }
}
