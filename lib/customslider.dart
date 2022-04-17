import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'dart:ui' as ui;

class SliderThumbImage extends SliderComponentShape {
  final ui.Image? image;

  SliderThumbImage(this.image);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(0, 0);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    Size? sizeWithOverflow,
    double? textScaleFactor,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
  }) {
    final canvas = context.canvas;
    final imageWidth = image?.width ?? 10;
    final imageHeight = image?.height ?? 10;

    Offset imageOffset = Offset(
      center.dx - (imageWidth / 2),
      center.dy - (imageHeight / 2),
    );

    Paint paint = Paint()..filterQuality = FilterQuality.high;

    if (image != null) {
      canvas.drawImage(image!, imageOffset, paint);
    }
  }
}

class SliderWidget extends StatefulWidget {
  final double sliderHeight, width;
  final int min;
  final int max;
  final bool fullWidth;
  final ui.Image? image;
  Function(double v) onchange;
  double value;

  SliderWidget({
    Key? key,
    this.sliderHeight = 48,
    required this.max,
    required this.min,
    this.fullWidth = false,
    this.image,
    required this.width,
    required this.onchange,
    required this.value,
  }) : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (widget.fullWidth) paddingFactor = .3;

    return SizedBox(
      width: widget.width - 20,
      height: (widget.sliderHeight),
      child: Padding(
        padding: EdgeInsets.fromLTRB(widget.sliderHeight * paddingFactor, 2,
            widget.sliderHeight * paddingFactor, 2),
        child: Row(
          children: <Widget>[
            Text(
              '${widget.min}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.sliderHeight * .3,
                fontWeight: FontWeight.w700,
              ),
            ),
            Expanded(
                child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.blue[800],
                inactiveTrackColor: Colors.blue[800]?.withOpacity(.7),

                trackHeight: 4.0,
                thumbShape: SliderThumbImage(widget.image),
                overlayColor: Colors.blue[100]?.withOpacity(.4),
                //valueIndicatorColor: Colors.white,
                activeTickMarkColor: Colors.white,
                inactiveTickMarkColor: Colors.red.withOpacity(.7),
              ),
              child: Slider(
                value: widget.value,
                min: widget.min.toDouble(),
                max: widget.max.toDouble(),
                onChanged: widget.onchange,
              ),
            )),
            Text(
              '${widget.max}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.sliderHeight * .3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
