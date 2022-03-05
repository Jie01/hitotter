import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:game2/constants.dart';
import 'package:game2/home.dart';

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

  List images = [
    "lutra0",
    "lutra1",
    "sign0",
    "sign1",
    "sign2",
    "sign3",
    "sign4",
    "1",
    "2",
    "bite",
  ];

  late bool load;

  @override
  void initState() {
    load = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: key,
      drawer: Container(
        color: Colors.white,
        width: size.width / 2.5,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: const [
            Text("之後加吧\n 耶嘿>30"),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/3.png"),
          fit: BoxFit.fitWidth,
        )),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: SizedBox(
          child: !load
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "哇嘎乃030",
                      style: TextStyle(
                          fontSize:
                              size.width > 660 ? size.width * (5 / 96) : 34),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          load = true;
                        });
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
                                        child: const Text("我知道"))
                                  ],
                                )).then((value) {
                          Timer(const Duration(milliseconds: 1000), () {
                            for (String i in images) {
                              precacheImage(
                                  AssetImage("assets/images/char/$i.png"),
                                  context);
                            }

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GHome(round: 0)));
                          });
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
                )
              : Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
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
                  ),
                ),
        ),
      ),
    );
  }
}
