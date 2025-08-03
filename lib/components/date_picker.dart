import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mal3b/constants/colors.dart';

class DatePickerRow extends StatefulWidget {
  @override
  _DatePickerRowState createState() => _DatePickerRowState();
}

class _DatePickerRowState extends State<DatePickerRow> {
  DateTime? fromDate;
  DateTime? toDate;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final now = DateTime.now();
    final initial = isFromDate
        ? (fromDate ?? now)
        : (toDate ??
              (fromDate != null && fromDate!.isAfter(now) ? fromDate! : now));

    final first = isFromDate ? now : (fromDate ?? now);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first) ? first : initial,
      firstDate: first,
      lastDate: DateTime(2026),
      locale: const Locale('ar'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: CustomColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.primary,
              ),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
          // Reset toDate if it became earlier than fromDate
          if (toDate != null && toDate!.isBefore(fromDate!)) {
            toDate = null;
          }
        } else {
          toDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final formatter = DateFormat('d MMMM yyyy', 'ar');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "التاريخ",
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
                onPressed: () => _selectDate(context, true),
                style: ElevatedButton.styleFrom(
                  foregroundColor: CustomColors.primary,
                  backgroundColor: CustomColors.white,
                  shadowColor: Colors.transparent,
                  side: BorderSide(color: CustomColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  fromDate == null ? 'من' : _formatDate(fromDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _selectDate(context, false),
                style: ElevatedButton.styleFrom(
                  foregroundColor: CustomColors.primary,
                  backgroundColor: CustomColors.white,
                  shadowColor: Colors.transparent,
                  side: BorderSide(color: CustomColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  toDate == null ? 'إلى' : _formatDate(toDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
