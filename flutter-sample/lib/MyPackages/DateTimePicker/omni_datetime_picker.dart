import 'package:flutter/material.dart';
import './src/omni_datetime_picker.dart';

Future<DateTime?> showOmniDateTimePicker({
  required BuildContext context,
  Widget? title,
  Widget? separator,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  bool? is24HourMode,
  bool? isShowSeconds,
  int? minutesInterval,
  int? secondsInterval,
  bool? isForce2Digits,
  BorderRadiusGeometry? borderRadius,
  BoxConstraints? constraints,
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
      transitionBuilder,
  Duration? transitionDuration,
  bool? barrierDismissible,
  OmniDateTimePickerType type = OmniDateTimePickerType.dateAndTime,
  final bool Function(DateTime)? selectableDayPredicate,
  ThemeData? theme,
}) {
  return showGeneralDialog(
    context: context,
    transitionBuilder: transitionBuilder ??
        (context, anim1, anim2, child) {
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
    transitionDuration: transitionDuration ?? const Duration(milliseconds: 200),
    barrierDismissible: barrierDismissible ?? true,
    barrierLabel: 'OmniDateTimePicker',
    pageBuilder: (BuildContext context, anim1, anim2) {
      return Theme(
        data: theme ?? Theme.of(context),
        child: OmniDateTimePicker(
          separator: separator,
          title: title,
          type: type,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          is24HourMode: is24HourMode,
          isShowSeconds: isShowSeconds,
          minutesInterval: minutesInterval,
          secondsInterval: secondsInterval,
          isForce2Digits: isForce2Digits,
          borderRadius: borderRadius,
          constraints: constraints,
          selectableDayPredicate: selectableDayPredicate,
        ),
      );
    },
  );
}

enum OmniDateTimePickerType {
  time,
  date,
  dateAndTime,
}
