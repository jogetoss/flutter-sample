import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:joget/Utilities/Functions.dart';

class TextFieldMaskingElement extends StatefulWidget {
  Key? key;
  String? id;
  String? label;
  TextFieldMaskingElement({this.key, required this.id, required this.label});

  @override
  _TextFieldMaskingElementState createState() =>
      _TextFieldMaskingElementState();
}

class _TextFieldMaskingElementState extends State<TextFieldMaskingElement> {
  final maskFormatter = MaskTextInputFormatter(mask: '(###) ###-####');
  final TextEditingController controller = TextEditingController();

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
        TextField(
          selectionControls: CustomColorSelectionHandle(Colors.grey),
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [maskFormatter],
          decoration: const InputDecoration(
            hintStyle: TextStyle(color: Colors.grey),
            hintText: '(___) ___-____',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
