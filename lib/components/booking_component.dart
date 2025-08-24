import 'package:flutter/material.dart';
import 'package:mal3b/constants/colors.dart';

class BookingComponent extends StatelessWidget {
  final String name;
  final String date;
  final String from;
  final String to;
  final String amprice;
  final String pmprice;

  const BookingComponent({
    super.key,
    required this.name,
    required this.date,
    required this.from,
    required this.to,
    required this.amprice,
    required this.pmprice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 35),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: CustomColors.primary,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                name,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                date,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  from,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Text(
                  ':',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  to,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Text(
                    '$amprice جنيه / الساعة صباحًا',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    '$pmprice جنيه / الساعة مساءً',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
