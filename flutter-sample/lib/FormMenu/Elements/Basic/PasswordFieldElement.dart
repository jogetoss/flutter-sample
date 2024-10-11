import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:joget/Utilities/Functions.dart';

class PasswordFieldElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  String value = "";
  PasswordFieldElement({this.key, required this.id, required this.label});

  @override
  State<PasswordFieldElement> createState() => _PasswordFieldElementState();
}

class _PasswordFieldElementState extends State<PasswordFieldElement> {
  TextEditingController controller = TextEditingController();
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
        TextField(
          selectionControls: CustomColorSelectionHandle(Colors.grey),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          controller: controller,
          onChanged: (value) {
            widget.value = value;
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
