import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:joget/MyPackages/DateTimePicker/omni_datetime_picker.dart';
// import 'package:joget/MyPackages/OmniDateTimePicker-main/lib/omni_datetime_picker.dart';

class TimePickerElement extends StatefulWidget {
  final String id;
  final String label;
  String value;

  TimePickerElement(
      {Key? key, required this.id, required this.label, this.value = ""})
      : super(key: key);

  @override
  _TimePickerElementState createState() => _TimePickerElementState();
}

class _TimePickerElementState extends State<TimePickerElement> {
  // TimeOfDay? selectedTime;
  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.value.isNotEmpty) {
  //     selectedTime = TimeOfDay.fromDateTime(DateTime.parse(widget.value));
  //   }
  // }
  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     useRootNavigator: true,
  //     initialEntryMode: TimePickerEntryMode.inputOnly,
  //     helpText: "",
  //     context: context,
  //     initialTime: selectedTime ?? TimeOfDay.now(),
  //     builder: (context, child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           colorScheme: const ColorScheme.light(
  //             // primaryContainer: Colors.red,
  //             // onPrimaryContainer: Colors.green,
  //             // secondary: Colors.yellow,
  //             // onSecondary: Colors.blue,
  //             // secondaryContainer: Colors.purple,
  //             // onSecondaryContainer: Colors.teal,
  //             // tertiary: Colors.cyan,
  //             // onTertiary: Colors.indigo,
  //             // tertiaryContainer: Colors.orange,
  //             // onTertiaryContainer: Colors.red,
  //             // error: Colors.red,
  //             // onError: Colors.red,
  //             // errorContainer: Colors.red,
  //             // onErrorContainer: Colors.red,
  //             // background: Colors.red,
  //             // onBackground: Colors.red,
  //             // surfaceVariant: Colors.red,
  //             // onSurfaceVariant: Colors.red,
  //             // shadow: Colors.red,
  //             // scrim: Colors.red,
  //             // inverseSurface: Colors.red,
  //             // onInverseSurface: Colors.red,
  //             // inversePrimary: Colors.red,
  //             // surfaceTint: Colors.red,
  //             outline: Colors.white,
  //             outlineVariant: Colors.white,
  //             primary: Colors.white,
  //             onPrimary: Colors.grey,
  //             surface: Colors.grey,
  //             onSurface: Colors.white,
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //   if (pickedTime != null && pickedTime != selectedTime) {
  //     setState(() {
  //       selectedTime = pickedTime;
  //       widget.value = DateFormat.Hm().format(
  //         DateTime(2024, 1, 1, pickedTime.hour, pickedTime.minute),
  //       );
  //     });
  //   }
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
        const SizedBox(height: 10),
        // GestureDetector(
        //   onTap: () => _selectTime(context),
        //   child: AbsorbPointer(
        //     child: TextFormField(
        //       controller: TextEditingController(
        //         text: selectedTime != null ? selectedTime!.format(context) : '',
        //       ),
        //       decoration: const InputDecoration(
        //         suffixIcon: Icon(
        //           Icons.access_time,
        //           color: Colors.grey,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                DateTime? dateTime = await showOmniDateTimePicker(
                  type: OmniDateTimePickerType.date,
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate:
                      DateTime(1600).subtract(const Duration(days: 3652)),
                  lastDate: DateTime.now().add(
                    const Duration(days: 3652),
                  ),
                  is24HourMode: true,
                  isShowSeconds: false,
                  minutesInterval: 1,
                  secondsInterval: 1,
                  isForce2Digits: true,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  constraints: const BoxConstraints(
                    maxWidth: 350,
                    maxHeight: 650,
                  ),
                  transitionBuilder: (context, anim1, anim2, child) {
                    return FadeTransition(
                      opacity: anim1.drive(
                        Tween(
                          begin: 0,
                          end: 1,
                        ),
                      ),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 200),
                  barrierDismissible: true,
                  selectableDayPredicate: (dateTime) {
                    // Disable 25th Feb 2023
                    if (dateTime == DateTime(2023, 2, 25)) {
                      return false;
                    } else {
                      return true;
                    }
                  },
                );
                print("dateTime: $dateTime");
              },
              child: const Text("Show DateTime Picker"),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
