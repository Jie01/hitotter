import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game2/constants.dart';
import 'package:game2/home.dart';
import 'package:game2/setting.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AudioManager.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '我就不會想名字.w.',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'regular'),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: key,
      drawer: const Kdrawer(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/NoCute.png"),
          fit: BoxFit.fitWidth,
        )),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "哇嘎乃030",
                style: TextStyle(
                    fontSize: size.width > 660 ? size.width * (5 / 96) : 34),
              ),
              GestureDetector(
                onTap: () {
                  // setState(() {
                  //   load = true;
                  // });
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                            title: const Text('介紹'),
                            content: const Text(rule),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("開始 (>ω<)"))
                            ],
                          )).then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GHome(round: 1)));
                  });
                },
                child: const Text(
                  "開始",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              GestureDetector(
                onTap: () {
                  key.currentState?.openDrawer();
                },
                child: const Text(
                  "設定",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
          // : Center(
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(
          //           horizontal: 20, vertical: 15),
          //       color: Colors.blue[800]!.withOpacity(0.4),
          //       child: Row(
          //         // mainAxisAlignment: MainAxisAlignment.center,
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Image.asset(
          //             "assets/images/loading.gif",
          //             height: 60.0,
          //             width: 60.0,
          //             fit: BoxFit.contain,
          //           ),
          //           const SizedBox(width: 20),
          //           const Text(
          //             "Loading...",
          //             style: TextStyle(
          //                 fontSize: 50,
          //                 fontWeight: FontWeight.bold,
          //                 color: Color(0xff030F36)),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
        ),
      ),
    );
  }
}
