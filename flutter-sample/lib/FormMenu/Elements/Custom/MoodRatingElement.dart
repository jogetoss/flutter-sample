import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class MoodRatingElement extends StatefulWidget {
  Key? key;
  String id;
  int? value = 5;
  String label;
  String className;
  MoodRatingElement(
      {this.key,
      required this.id,
      required this.label,
      required this.className});
  @override
  State<MoodRatingElement> createState() => _MoodRatingElementState();
}

class _MoodRatingElementState extends State<MoodRatingElement> {
  late int _rating = 5;

  @override
  void initState() {
    super.initState();
  }

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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              style: const ButtonStyle(
                surfaceTintColor: MaterialStatePropertyAll(Colors.black),
                elevation: MaterialStatePropertyAll(4),
              ),
              icon: Image.asset(
                  width: 40, 'assets/images/MoodRatingElement/love-eyes.png'),
              onPressed: () {
                setState(() {});
              },
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Image.asset(
                    width: 40, 'assets/images/MoodRatingElement/laugh.png'),
                onPressed: () {
                  setState(() {});
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Image.asset(
                    width: 40, 'assets/images/MoodRatingElement/smile.png'),
                onPressed: () {
                  setState(() {});
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Image.asset(
                    width: 40, 'assets/images/MoodRatingElement/sad-tears.png'),
                onPressed: () {
                  setState(() {});
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Image.asset(
                    width: 40, 'assets/images/MoodRatingElement/disgusted.png'),
                onPressed: () {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
