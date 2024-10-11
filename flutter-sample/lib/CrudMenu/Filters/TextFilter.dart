import 'package:flutter/material.dart';
import 'package:joget/Utilities/Functions.dart';

class TextFilter extends StatefulWidget {
  Key? key;
  String columnName;
  String label;
  TextFilter({this.key, required this.columnName, required this.label});
  TextEditingController controller = TextEditingController();
  @override
  _TextFilterState createState() => _TextFilterState();
}

class _TextFilterState extends State<TextFilter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        selectionControls: CustomColorSelectionHandle(Colors.grey),
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.columnName,
        ),
      ),
    );
  }
}
