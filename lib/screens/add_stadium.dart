import 'package:flutter/material.dart';



class AddStadium extends StatefulWidget {
  const AddStadium({super.key});

  @override
  State<AddStadium> createState() => _AddStadiumState();
}

class _AddStadiumState extends State<AddStadium> {

 @override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Your stadium list / form / content here
        Center(child: Text('ضيف ملعب', style: TextStyle(fontSize: 24)))

      ],
    ),
  );
}
}