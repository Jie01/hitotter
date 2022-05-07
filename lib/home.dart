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
  late bool loading;

  @override
  void initState() {
    baseGame = GameHitOtter(context, widget.round);
    loading = true;

    Future.delayed(
        Duration(milliseconds: 500),
        () => setState(() {
              for (String i in images) {
                precacheImage(AssetImage("assets/images/char/$i.png"), context);
              }
              loading = false;
            }));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: loading
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                color: Colors.blue[800]!.withOpacity(0.4),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/loading.gif",
                      height: 60.0,
                      width: 60.0,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Loading...",
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff030F36)),
                    ),
                  ],
                ),
              )
            : SizedBox(
                width: (size.height - 60) * screenFactor,
                height: size.height - 60,
                child: GameWidget(
                  game: baseGame,
                ),
              ),
      ),
    );
  }
}
