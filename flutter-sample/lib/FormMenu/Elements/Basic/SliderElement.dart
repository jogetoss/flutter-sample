import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class SliderElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  String value = "";
  SliderElement({this.key, required this.id, required this.label});

  @override
  State<SliderElement> createState() => _SliderElementState();
}

class _SliderElementState extends State<SliderElement> {
  double currentValue = 50;

  getCurrentValueAsInt() {
    return currentValue.toInt().toString();
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
        Slider(
          thumbColor: Colors.grey,
          activeColor: Colors.grey,
          overlayColor: MaterialStatePropertyAll(Colors.transparent),
          inactiveColor: Colors.grey,
          secondaryActiveColor: Colors.grey,
          value: currentValue,
          min: 0,
          max: 100,
          divisions: 100,
          label: getCurrentValueAsInt(),
          onChanged: (double value) {
            setState(() {
              currentValue = value;
            });
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
