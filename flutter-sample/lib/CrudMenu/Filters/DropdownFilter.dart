import 'package:flutter/material.dart';

class DropdownFilter extends StatefulWidget {
  Key? key;
  String columnName;
  String label;
  List<dynamic> rawOptions;
  String selectedOption = "";
  DropdownFilter(
      {this.key,
      required this.columnName,
      required this.label,
      required this.rawOptions});
  @override
  _DropdownFilterState createState() => _DropdownFilterState();
}

class _DropdownFilterState extends State<DropdownFilter> {
  List<String> options = [];
  String x = "";
  @override
  void initState() {
    super.initState();
    options.add(widget.columnName);
    for (var item in widget.rawOptions) {
      options.add(item['label']!);
    }
    x = options[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton(
        isDense: true,
        iconEnabledColor: Colors.grey,
        isExpanded: true,
        borderRadius: BorderRadius.circular(10),
        underline: Container(),
        padding: const EdgeInsets.all(15.0),
        hint: Text(
          style: const TextStyle(color: Colors.black),
          x,
        ),
        onChanged: (value) {
          setState(() {
            x = value!;
            if (value != widget.columnName) {
              widget.selectedOption = value;
            } else {
              widget.selectedOption = "";
            }
          });
        },
        items: options.map((String val) {
          return DropdownMenuItem(
            value: val,
            child: Text(
              val,
            ),
          );
        }).toList(),
      ),
    );
  }
}
