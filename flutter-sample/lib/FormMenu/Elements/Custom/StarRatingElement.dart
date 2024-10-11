import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class StarRatingElement extends StatefulWidget {
  Key? key;
  String? className;
  String? id;
  String? label;
  int? value;
  StarRatingElement({
    this.key,
    required this.className,
    required this.id,
    required this.label,
  });
  @override
  State<StarRatingElement> createState() => _StarRatingElementState();
}

class _StarRatingElementState extends State<StarRatingElement> {
  int rating = 1;

  @override
  void initState() {
    super.initState();
    widget.value = rating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HtmlWidget(
          widget.label!,
          textStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            return Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  size: 40,
                  index < rating ? Icons.star : Icons.star,
                  color: index < rating ? HexColor("#ff7700") : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    rating = index + 1;
                    widget.value = index + 1;
                  });
                },
              ),
            );
          }),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
