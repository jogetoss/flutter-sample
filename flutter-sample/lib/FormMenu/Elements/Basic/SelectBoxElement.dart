import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:joget/Utilities/Global.dart' as globals;
import 'package:hexcolor/hexcolor.dart';

class SelectBoxElement extends StatefulWidget {
  Key? key;
  String? className;
  String? id;
  String? label;
  String? value;
  List<dynamic>? options;
  ElementController controllerElement;
  dynamic validator;
  bool isValidationError = false;
  SelectBoxElement(
      {this.key,
      required this.className,
      required this.id,
      required this.label,
      required this.value,
      required this.options,
      required this.controllerElement,
      required this.validator});
  @override
  State<SelectBoxElement> createState() => _SelectBoxElementState();
}

class _SelectBoxElementState extends State<SelectBoxElement> {
  bool showErrorMessage = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    if (widget.value == "") {
      if (widget.options!.isNotEmpty) {
        widget.value = widget.options![0]['value'];
      }
    }
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
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: HexColor(globals.colorTextField),
            ),
          ),
          child: DropdownButton(
            isDense: true,
            iconEnabledColor: HexColor(globals.colorTextField),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            underline: Container(),
            padding: const EdgeInsets.all(15),
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                widget.value = value.toString();
              });
            },
            value: widget.value,
            items: widget.options!.map<DropdownMenuItem<String>>((option) {
              return DropdownMenuItem(
                value: option['value'],
                child: Text(
                  option['label'],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
