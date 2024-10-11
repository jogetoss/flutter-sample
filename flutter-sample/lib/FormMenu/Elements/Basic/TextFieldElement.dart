import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:joget/Utilities/Global.dart' as globals;
import 'package:hexcolor/hexcolor.dart';

class TextFieldElement extends StatefulWidget {
  Key? key;
  String? className;
  String? id;
  String? label;
  String? value;
  ElementController controllerElement;
  dynamic validator;
  bool isValidationError = false;
  TextFieldElement(
      {this.key,
      required this.className,
      required this.id,
      required this.label,
      required this.value,
      required this.controllerElement,
      required this.validator});
  @override
  State<TextFieldElement> createState() => _TextFieldElementState();
}

class _TextFieldElementState extends State<TextFieldElement> {
  TextEditingController controller = TextEditingController();
  bool showErrorMessage = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    controller.text = widget.value!;
    widget.controllerElement.setRefresh(refresh);
  }

  refresh() {
    setState(() {
      Map<String, dynamic> validationResult =
          widget.validator.validate(widget.value);
      errorMessage = validationResult['message'];
      showErrorMessage = validationResult['isValidationError'];
      widget.isValidationError = validationResult['isValidationError'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HtmlWidget(
          widget.label!,
          textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: HexColor(globals.colorTextField)),
        ),
        const SizedBox(
          height: 10,
        ),
        showErrorMessage
            ? Text(errorMessage, style: const TextStyle(color: Colors.red))
            : const SizedBox(),
        const SizedBox(
          height: 10,
        ),
        TextField(
          selectionControls:
              CustomColorSelectionHandle(HexColor(globals.colorTextField)),
          onChanged: (value) {
            setState(() {
              widget.value = value;
            });
          },
          controller: controller,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
