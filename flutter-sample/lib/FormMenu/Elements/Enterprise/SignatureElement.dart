import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class SignatureElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  SignatureElement({
    this.key,
    required this.id,
    required this.label,
  });

  @override
  _SignatureElementState createState() => _SignatureElementState();
}

class _SignatureElementState extends State<SignatureElement> {
  final GlobalKey<SignatureState> _signatureKey = GlobalKey<SignatureState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HtmlWidget(
          widget.label,
          textStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.transparent,
            ),
            height: 300,
            width: double.maxFinite,
            child: Signature(
              key: _signatureKey,
              strokeWidth: 2.0,
            )),
        const SizedBox(
          height: 5,
        ),
        ElevatedButton(
          onPressed: () {
            if (_signatureKey.currentState != null) {
              _signatureKey.currentState?.clear();
            }
          },
          style: ButtonStyle(
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.grey),
          ),
          child: const Text("Clear"),
        ),
        const SizedBox(
          height: 5,
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_signatureKey.currentState != null) {
                List<Offset?> offsets = _signatureKey.currentState!.points;
                List<Map<String, int>> convertedList = [];
                for (var offset in offsets) {
                  if (offset != null) {
                    convertedList.add({
                      "lx": offset.dx.toInt(),
                      "ly": offset.dy.toInt(),
                      "mx": offset.dx.toInt(),
                      "my": offset.dy.toInt(),
                    });
                  }
                }
              }
            });
          },
          style: ButtonStyle(
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.grey),
          ),
          child: const Text("Show Points"),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}




/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class SignatureElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  Function disableListViewScrolling;
  SignatureElement(
      {this.key,
      required this.id,
      required this.label,
      required this.disableListViewScrolling});

  @override
  _SignatureElementState createState() => _SignatureElementState();
}

class _SignatureElementState extends State<SignatureElement> {
  List<Map<String, int>> points = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HtmlWidget(
          widget.label,
          // textScaler: const TextScaler.linear(1.2),
          textStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.transparent,
          ),
          height: 300,
          width: double.maxFinite,
          child: GestureDetector(
            onPanEnd: (details) {
              setState(() {
                widget.disableListViewScrolling(true);
              });
            },
            onPanDown: (details) {
              setState(() {
                widget.disableListViewScrolling(false);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                points.add({
                  'lx': points.isEmpty
                      ? details.localPosition.dx.toInt()
                      : points.last['mx']!,
                  'ly': points.isEmpty
                      ? details.localPosition.dy.toInt()
                      : points.last['my']!,
                  'mx': details.localPosition.dx.toInt(),
                  'my': details.localPosition.dy.toInt(),
                });
              });
            },
            child: 
            CustomPaint(
              painter: SignaturePainter(points: points),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              points.clear();
            });
          },
          style: ButtonStyle(
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.grey),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: const Text("Clear"),
        ),
        const SizedBox(
          height: 5,
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              String pointsJsonEncoded = jsonEncode(points);
            });
          },
          style: ButtonStyle(
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.grey),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: const Text("Show Points"),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  bool _isPointerInside(Offset localPosition) {
    return localPosition.dx >= 5 &&
        localPosition.dx <= 295 &&
        localPosition.dy >= 5 &&
        localPosition.dy <= 195;
  }
}

class SignaturePainter extends CustomPainter {
  List<Map<String, int>> points;

  SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          Offset(points[i]['lx']!.toDouble(), points[i]['ly']!.toDouble()),
          Offset(points[i]['mx']!.toDouble(), points[i]['my']!.toDouble()),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
*/