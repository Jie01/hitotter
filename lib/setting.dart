import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game2/constants.dart';
import 'package:game2/customslider.dart';

class Kdrawer extends StatefulWidget {
  const Kdrawer({Key? key}) : super(key: key);

  @override
  KdrawerState createState() => KdrawerState();
}

class KdrawerState extends State<Kdrawer> {
  bool loading = true;

  @override
  void initState() {
    loading = true;
    getUiImage("assets/images/foot.png", 10, 10)
        .then((value) => setState(() => loading = false));
    super.initState();
  }

  Future<ui.Image> getUiImage(
      String imageAssetPath, int height, int width) async {
    final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
    final codec = await ui.instantiateImageCodec(
      assetImageByteData.buffer.asUint8List(),
      targetHeight: height,
      targetWidth: width,
    );

    final image = (await codec.getNextFrame()).image;
    sliderimage = image;

    return image;
  }

  ui.Image? sliderimage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width > 870 ? size.width / 2.5 : size.width / 1.5,
      decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("assets/images/drawerbg.png"),
              fit: BoxFit.fill)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset("assets/images/header.png"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "聲音",
                        style: mediumstyle,
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.volume_up,
                        size: 33,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        volume.toInt().toString(),
                        style: mediumstyle,
                      ),
                    ],
                  ),
                  !loading
                      ? SliderWidget(
                          image: sliderimage,
                          width: size.width > 870
                              ? size.width / 2.5
                              : size.width / 1.5,
                          value: volume,
                          max: 100,
                          min: 0,
                          onchange: (value) {
                            setState(() {
                              volume = value;
                            });
                          })
                      : const CircularProgressIndicator(),
                  Row(
                    children: [
                      const Text(
                        "回合數量",
                        style: mediumstyle,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        maxRound.toString(),
                        style: mediumstyle,
                      ),
                    ],
                  ),
                  !loading
                      ? SliderWidget(
                          image: sliderimage,
                          width: size.width > 870
                              ? size.width / 2.5
                              : size.width / 1.5,
                          value: maxRound.toDouble(),
                          max: 10,
                          min: 1,
                          onchange: (value) {
                            setState(() {
                              maxRound = value.toInt();
                            });
                          })
                      : const CircularProgressIndicator(),
                  Row(
                    children: [
                      const Text(
                        "水獺數量",
                        style: mediumstyle,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        maxOtter.toString(),
                        style: mediumstyle,
                      ),
                    ],
                  ),
                  !loading
                      ? SliderWidget(
                          image: sliderimage,
                          width: size.width > 870
                              ? size.width / 2.5
                              : size.width / 1.5,
                          value: maxOtter.toDouble(),
                          max: 30,
                          min: 9,
                          onchange: (value) {
                            setState(() {
                              maxOtter = value.toInt();
                            });
                          })
                      : const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
          Image.asset("assets/images/footer.png"),
        ],
      ),
    );
  }
}
