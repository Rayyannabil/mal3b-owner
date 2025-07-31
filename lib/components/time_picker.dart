import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mal3b/constants/colors.dart';

class TimeRangePicker extends StatefulWidget {
  final void Function(String startFormatted, String endFormatted)
  onTimeRangeSelectedFormatted;

  const TimeRangePicker({
    super.key,
    required this.onTimeRangeSelectedFormatted,
  });

  @override
  State<TimeRangePicker> createState() => _TimeRangePickerState();
}

class _TimeRangePickerState extends State<TimeRangePicker> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String formatTo24Hour(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm:ss').format(dt); // => 13:00:00
  }

  Future<void> _pickTime({required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: CustomColors.customWhite,
              dialHandColor: CustomColors.primary,
              hourMinuteColor: MaterialStateColor.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? CustomColors.primary
                    : CustomColors.white,
              ),
              hourMinuteTextColor: MaterialStateColor.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? CustomColors.white
                    : CustomColors.secondary,
              ),
              entryModeIconColor: CustomColors.secondary,
              dayPeriodColor: MaterialStateColor.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? CustomColors.primary
                    : CustomColors.white,
              ),
              dayPeriodTextColor: MaterialStateColor.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? CustomColors.white
                    : CustomColors.secondary,
              ),
            ),
            colorScheme: ColorScheme.light(
              primary: CustomColors.primary,
              onPrimary: CustomColors.white,
              onSurface: CustomColors.secondary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });

      if (_startTime != null && _endTime != null) {
        final startFormatted = formatTo24Hour(_startTime!);
        final endFormatted = formatTo24Hour(_endTime!);
        widget.onTimeRangeSelectedFormatted(startFormatted, endFormatted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ساعات العمل",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: CustomColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _pickTime(isStart: true),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,

                  foregroundColor: CustomColors.primary,
                  backgroundColor: CustomColors.white,
                  side: BorderSide(
                    color: CustomColors.primary,
                    width: 2,
                  ), // Border here
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: Text(
                  _startTime == null ? 'من' : _startTime!.format(context),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _pickTime(isStart: false),
                style: ElevatedButton.styleFrom(
                  foregroundColor: CustomColors.primary,
                  backgroundColor: CustomColors.white,
                  shadowColor: Colors.transparent,
                  side: BorderSide(
                    color: CustomColors.primary,
                    width: 2,
                  ), // Border here
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _endTime == null ? 'إلى' : _endTime!.format(context),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
