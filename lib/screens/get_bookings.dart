import 'package:flutter/material.dart';

class GetBookings extends StatefulWidget {
  const GetBookings({super.key});

  @override
  State<GetBookings> createState() => _GetBookingsState();
}

class _GetBookingsState extends State<GetBookings> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Your stadium list / form / content here
        Center(child: Text('الحجوزات', style: TextStyle(fontSize: 24)))

      ],
    ),
  );
  }
}
