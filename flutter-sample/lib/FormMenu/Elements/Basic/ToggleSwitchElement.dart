import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ToggleSwitchElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  String value = "";
  ToggleSwitchElement({this.key, required this.id, required this.label});

  @override
  State<ToggleSwitchElement> createState() => _ToggleSwitchElementState();
}

class _ToggleSwitchElementState extends State<ToggleSwitchElement> {
  bool isOn = false;

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
        Transform.scale(
          scale: 1.1,
          child: Switch(
              thumbColor: MaterialStatePropertyAll(Colors.white),
              trackColor: MaterialStatePropertyAll(Colors.grey),
              trackOutlineColor: MaterialStatePropertyAll(Colors.grey),
              value: isOn,
              onChanged: (value) {
                setState(() {
                  isOn = value;
                });
              }),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
