import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:joget/Utilities/Functions.dart';

class ColorPickerElement extends StatefulWidget {
  Key? key;
  String? className;
  String? id;
  String? label;
  String? value;
  ColorPickerElement({
    this.key,
    required this.className,
    required this.id,
    required this.label,
    required this.value,
  });
  @override
  State<ColorPickerElement> createState() => _ColorPickerElementState();
}

class _ColorPickerElementState extends State<ColorPickerElement> {
  String currentColor = "";
  List<String> options = [
    '#16a085',
    '#16a085',
    '#2ecc71',
    '#27ae60',
    '#3498db',
    '#2980b9',
    '#9b59b6',
    '#34495e',
    '#2c3e50',
    '#f1c40f',
    '#f39c12',
    '#e67e22',
    '#d35400',
    '#e74c3c',
    '#c0392b',
    '#ecf0f1',
    '#bdc3c7',
    '#95a5a6',
    '#7f8c8d'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.value == "") {
      currentColor = options[0];
      widget.value = currentColor;
    } else {
      currentColor = widget.value!;
    }
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
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.all(15.0),
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GridView.count(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 4,
                              children: options.map((String color) {
                                return Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        currentColor = color;
                                        widget.value = color;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              HexColor(color)),
                                    ),
                                    child: const SizedBox(),
                                  ),
                                );
                              }).toList()),
                        ),
                      ),
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(HexColor(currentColor)),
              ),
              child: const Text("")),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
