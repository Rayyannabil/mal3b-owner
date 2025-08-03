import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/date_picker.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/logic/cubit/stadium_cubit.dart';

class MyFields extends StatefulWidget {
  const MyFields({super.key});

  @override
  State<MyFields> createState() => _MyFieldsState();
}

class _MyFieldsState extends State<MyFields> {
  String formatTimeArabic(String timeString) {
  final inputFormat = DateFormat("HH:mm:ss");
  final outputFormat = DateFormat.jm("en"); 
  final time = inputFormat.parse(timeString);
  return outputFormat.format(time);
}

  @override
  void initState() {
    super.initState();
    context.read<StadiumCubit>().fetchStadiums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                              Padding(padding: EdgeInsets.only(top: 20)),
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
                              SizedBox(height: getVerticalSpace(context, 10)),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'الخصم',
                                        hintStyle: TextStyle(fontSize: 14),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 30,
                                        ), // تقليل الارتفاع
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ), // نفس الـ border radius
                                          borderSide: BorderSide(
                                            color: Colors.grey, // نفس اللون
                                            width: 1.5, // تخانة الحدود
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: CustomColors.primary,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
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
                          Padding(padding: EdgeInsets.only(top: 15)),
                          Divider(
                            indent: 10,
                            endIndent: 10,
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed('/bookings');
                                  },
                                  child: Text(
                                    'الحجوزات',
                                    style: TextStyle(
                                      color: CustomColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            indent: 10,
                            endIndent: 10,
                            color: Colors.grey,
                          ),
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
                                                  child: Text(
                                                    'إلغاء',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
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
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'حذف ملعب',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          SizedBox(
                                            width: getHorizontalSpace(
                                              context,
                                              150,
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
              child: BlocBuilder<StadiumCubit, StadiumState>(
                builder: (context, state) {
                  if (state is StadiumLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.primary,
                      ),
                    );
                  } else if (state is StadiumLoaded) {
                    final stadiums = state.stadiums;

                    if (stadiums.isEmpty) {
                      return const Center(
                        child: Text(
                          "لا توجد ملاعب حتى الآن",
                          style: TextStyle(
                            fontFamily: "MadaniArabic",
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap:
                          true, // يجعل ListView تأخذ فقط المساحة المطلوبة
                      physics:
                          NeverScrollableScrollPhysics(), // يمنع التمرير داخلها لأنها داخل SingleChildScrollView
                      itemCount: stadiums.length,

                      itemBuilder: (context, index) {
                        
                        final stadium = stadiums[index];

                        final name = stadium['name'] ?? '';
                        final amprice = stadium['price'] ?? '';
                        final pmprice = stadium['night_price'] ?? '';
                        final from = formatTimeArabic((stadium['from_time'])) ?? '';
                        final to = formatTimeArabic(stadium['to_time']) ?? '';

                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),

                            color: CustomColors.primary,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(15),
                            title: Text(
                              'ملعب ${name}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: getVerticalSpace(context, 10)),

                                Text(
                                  '${amprice} جنيه / الساعة صباحًا',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${pmprice} جنيه / الساعة مساء',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: getVerticalSpace(context, 10)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'من: ${from}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      width: getHorizontalSpace(context, 50),
                                    ),
                                    Text(
                                      'إلى: ${to}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            textColor: Colors.white,
                          ),
                        );
                      },
                    );
                  } else if (state is StadiumError) {
                    return Center(
                      child: Text(
                        state.msg,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: getFontTitleSize(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
