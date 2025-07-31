import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';

class MyFields extends StatefulWidget {
  const MyFields({super.key});

  @override
  State<MyFields> createState() => _MyFieldsState();
}

class _MyFieldsState extends State<MyFields> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your stadium list / form / content here
          Center(
            child: Text(
              'الملاعب',
              style: TextStyle(
                fontSize: getFontTitleSize(context) * 1.5,
                fontWeight: FontWeight.bold,
                color: CustomColors.secondary,
              ),
            ),
          ),
          SizedBox(height: getVerticalSpace(context, 20)),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(padding: EdgeInsetsGeometry.only(top: 20)),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'ضيف عرض',
                                style: TextStyle(
                                  color: CustomColors.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: getVerticalSpace(context, 5)),
                            DatePickerRow(),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'الخصم',
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF40513B),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'إضافة خصم',
                                      style: TextStyle(
                                        color: CustomColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsetsGeometry.only(top: 20)),
                        Divider(indent: 10, endIndent: 10, color: Colors.grey),
                        GestureDetector(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'الحجوزات',
                                style: TextStyle(color: CustomColors.primary),
                              ),
                            ),
                          ),
                        ),
                        Divider(indent: 10, endIndent: 10, color: Colors.grey),
                        GestureDetector(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: Text('تحذير'),
                                            content: Text(
                                              'هل أنت متأكد أنك تريد حذف الملعب؟',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                  ).pop(); // Close dialog
                                                },
                                                child: Text('إلغاء'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                  ).pop(); // Close dialog
                                                  // Put delete logic here
                                                  print('Deleted');
                                                },
                                                child: Text(
                                                  'حذف',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'حذف ملعب',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        SizedBox(
                                          width: getHorizontalSpace(
                                            context,
                                            170,
                                          ),
                                        ),
                                        Icon(Icons.delete, color: Colors.red),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Center(
                      child: CustomButton(
                        bgColor: CustomColors.primary,
                        fgColor: CustomColors.white,
                        onPressed: () => Navigator.of(context).pop(),
                        text: Text('إغلاق'),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                // image: DecorationImage(
                //   image: AssetImage('assets/images/championship.png'),
                //   fit: BoxFit.cover,
                // ),
                color: CustomColors.primary,
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(15),
                title: Text(
                  'نادي روما',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '300 جنيه / الساعة',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 25)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'من: 8 مساءًا',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        SizedBox(width: getHorizontalSpace(context, 50)),
                        Text(
                          'إلى: 8 مساءًا',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DatePickerRow extends StatefulWidget {
  @override
  _DatePickerRowState createState() => _DatePickerRowState();
}

class _DatePickerRowState extends State<DatePickerRow> {
  DateTime? fromDate;
  DateTime? toDate;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate
          ? fromDate ?? DateTime.now()
          : toDate ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
      locale: const Locale('ar'), // Optional: Arabic localization
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context, true),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'من',
                  hintText: fromDate == null
                      ? 'اختر التاريخ'
                      : '${fromDate!.year}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 25),
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context, false),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'إلى',
                  hintText: toDate == null
                      ? 'اختر التاريخ'
                      : '${toDate!.year}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
