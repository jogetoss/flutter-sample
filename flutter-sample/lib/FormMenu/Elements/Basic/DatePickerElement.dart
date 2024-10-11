import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:format_date/format_date.dart';

class DatePickerElement extends StatefulWidget {
  Key? key;
  String className;
  String id;
  String label;
  String value = "";
  String dataFormat = "";
  String format = "";
  // ElementController controllerElement;
  DatePickerElement({
    this.key,
    required this.className,
    required this.id,
    required this.label,
    required this.value,
    required this.format,
    required this.dataFormat,
    // required this.controllerElement
  });

  @override
  State<DatePickerElement> createState() => _DatePickerElementState();
}

class _DatePickerElementState extends State<DatePickerElement> {
  DateTime? selectedDate;

  bool showErrorMessage = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: "",
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              outline: Colors.white,
              outlineVariant: Colors.white,
              primary: Colors.white,
              onPrimary: Colors.grey,
              surface: Colors.grey,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        widget.value = DateFormat(widget.dataFormat).format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.parse(widget.value);
    // widget.controllerElement.setRefresh(refresh);
  }

  // refresh() {
  //   setState(() {
  //     showErrorMessage = true;
  //   });
  // }

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
        showErrorMessage
            ? const Text("Missing required field",
                style: TextStyle(color: Colors.red))
            : const SizedBox(),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextFormField(
              selectionControls: CustomColorSelectionHandle(Colors.grey),
              controller: TextEditingController(
                text: selectedDate != null
                    ? DateFormat(widget.format).format(selectedDate!)
                    : '',
              ),
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
