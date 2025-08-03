import 'package:flutter/material.dart';
import 'package:mal3b/components/booking_component.dart';
import 'package:mal3b/constants/colors.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            SafeArea(
              child: Center(
                child: Text(
                  'الحجوزات',
                  style: TextStyle(fontSize: 24, color: CustomColors.primary),
                ),
              ),
            ),
            BookingComponent(),
            Divider(indent: 50, endIndent: 50, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
