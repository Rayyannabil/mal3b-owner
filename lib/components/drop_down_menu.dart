import 'package:flutter/material.dart';
import 'package:mal3b/constants/colors.dart';

class DropDownMenu extends StatefulWidget {
  final List<String> items;
  final void Function(String?)? onChanged;
  final String selectedItem;

  const DropDownMenu({
    super.key,
    required this.items,
    this.onChanged,
    required this.selectedItem,
  });

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String walletSelected = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: CustomColors.customWhite,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            alignment: Alignment.bottomCenter,
            value: widget.items.contains(widget.selectedItem)
                ? widget.selectedItem
                : widget.items.first,
            hint: const Text(
              "اختار طريقة الدفع",
              style: TextStyle(fontFamily: 'MadaniArabic'),
            ),
            style: const TextStyle(
              fontFamily: "MadaniArabic",
              color: Colors.black, // لون النص واضح
              fontSize: 15,
            ),
            borderRadius: BorderRadius.circular(30),
            dropdownColor: Colors.white,
            isExpanded: true,
            onChanged: widget.onChanged,
            items: widget.items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(color: Colors.black)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
