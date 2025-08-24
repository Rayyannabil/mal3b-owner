import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mal3b/constants/colors.dart';

class SingleTimePicker extends StatefulWidget {
  final void Function(String formattedTime) onTimeSelected;

  const SingleTimePicker({
    super.key,
    required this.onTimeSelected,
  });

  @override
  State<SingleTimePicker> createState() => _SingleTimePickerState();
}

class _SingleTimePickerState extends State<SingleTimePicker> {
  TimeOfDay? _selectedTime;

  String formatTo24Hour(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm:ss').format(dt); // => 13:00:00
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
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
        _selectedTime = picked;
      });

      final formatted = formatTo24Hour(picked);
      widget.onTimeSelected(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "وقت بداية الليل",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: CustomColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickTime,
          style: ElevatedButton.styleFrom(
            foregroundColor: CustomColors.primary,
            backgroundColor: CustomColors.white,
            shadowColor: Colors.transparent,
            side: BorderSide(
              color: CustomColors.primary,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _selectedTime == null
                ? 'اختار الوقت'
                : _selectedTime!.format(context),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
