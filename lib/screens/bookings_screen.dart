import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mal3b/components/booking_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/logic/cubit/bookings_cubit.dart';

class BookingsScreen extends StatefulWidget {
  final String id;

  const BookingsScreen({super.key, required this.id});
  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingsCubit>().fetchBookings(widget.id);
  }

  String formatDateTime(String isoString) {
    final dateTime = DateTime.parse(
      isoString,
    ).toLocal(); // Convert to local time
    final formatter = DateFormat("dd MMMM yyyy - hh:mm a", "ar");

    String formatted = formatter.format(dateTime);

    // Replace Arabic numbers with English
    formatted = formatted.replaceAllMapped(RegExp(r'[\u0660-\u0669]'), (match) {
      return (match.group(0)!.codeUnitAt(0) - 0x0660).toString();
    });

    // Replace AM/PM with Arabics
    formatted = formatted.replaceAll("AM", "صباحًا").replaceAll("PM", "مساءً");

    return formatted;
  }

  String formatTimeWithoutSeconds(String timeString) {
    final parsedTime = DateFormat("HH:mm:ss").parse(timeString);
    String formattedTime = DateFormat("hh:mm a").format(parsedTime);

    formattedTime = formattedTime
        .replaceAll("AM", "صباحًا")
        .replaceAll("PM", "مساءً");

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<BookingsCubit, BookingsState>(
          builder: (context, state) {
            if (state is BookingsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: CustomColors.primary),
              );
            } else if (state is BookingsLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'الحجوزات',
                        style: TextStyle(
                          fontSize: 24,
                          color: CustomColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<BookingsCubit, BookingsState>(
                      builder: (context, state) {
                        if (state is BookingsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: CustomColors.primary,
                            ),
                          );
                        } else if (state is BookingsLoaded) {
                          final bookings = state.bookings;

                          if (bookings.isEmpty) {
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
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              final booking = bookings[index];

                              final id = booking['id'] ?? '';
                              final name = booking['name'] ?? '';
                              final date =
                                  formatDateTime(booking['booking_date']) ?? '';
                              final amprice = booking['price_per_hour'] ?? '';
                              final pmprice = booking['night_price'] ?? '';
                              final from =
                                  formatTimeWithoutSeconds(
                                    booking['from_time'],
                                  ) ??
                                  '';
                              final to =
                                  formatTimeWithoutSeconds(
                                    booking['to_time'],
                                  ) ??
                                  '';

                              log(to.toString());
                              return BookingComponent(
                                name: name,
                                date: date,
                                from: from,
                                to: to,
                                amprice: amprice,
                                pmprice: pmprice,
                              );
                            },
                          );
                        } else if (state is BookingsError) {
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
                  ],
                ),
              );
            } else if (state is BookingsError) {
              return Center(child: Text(state.msg));
            } else {
              return const Center(child: Text("لا توجد بيانات متاحة"));
            }
          },
        ),
      ),
    );
  }
}
