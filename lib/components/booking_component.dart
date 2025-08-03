// import 'package:flutter/material.dart';
// import 'package:mal3b/constants/colors.dart';
// import 'package:mal3b/helpers/size_helper.dart';

// class BookingComponent extends StatelessWidget {
//   const BookingComponent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 35),
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           color: CustomColors.primary,
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   'ريان نبيل',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                 top: 20,
//                 bottom: 10,
//                 right: 20,
//                 left: 20,
//               ),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   '1 مايو 2025',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   width: getHorizontalSpace(context, 160),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Center(
//                     child: Text(
//                       '8:00 م',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 Text(
//                   ':',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Container(
//                   width: getHorizontalSpace(context, 160),
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Center(
//                     child: Text(
//                       '10:00 م',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             Padding(
//               padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   '100 جنيه / الساعة',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';

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
