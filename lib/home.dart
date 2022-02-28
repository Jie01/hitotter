import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game2/constants.dart';
import 'package:game2/game.dart';

class GHome extends StatefulWidget {
  final int round;

  const GHome({Key? key, required this.round}) : super(key: key);

  @override
  _GHomeState createState() => _GHomeState();
}

class _GHomeState extends State<GHome> {
  late FlameGame baseGame;

  @override
  void initState() {
    baseGame = MyGame(context, widget.round);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: (size.height - 60) * screenfactor,
          height: size.height - 60,
          child: GameWidget(
            game: baseGame,
          ),
        ),
      ),
    );
  }
}
