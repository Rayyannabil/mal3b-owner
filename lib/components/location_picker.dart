// location_picker.dart

import 'package:flutter/material.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/services/location_service.dart';

class LocationPicker extends StatefulWidget {
  final Function(double lat, double lng, String address) onLocationPicked;

  const LocationPicker({super.key, required this.onLocationPicked});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  String _locationText = 'اختر الموقع';
  double? lat;
  double? lng;
  Future<void> _determinePosition() async {
    setState(() {
      _locationText = 'جاري تحديد الموقع...';
    });

    try {
      final position = await LocationService().getLongAndLat();
      final address = await LocationService().determinePosition();

      setState(() {
        _locationText = address;
        lat = position.latitude;
        lng = position.longitude;
      });

      widget.onLocationPicked(position.latitude, position.longitude, address);
    } catch (e) {
      setState(() {
        _locationText = 'فشل في جلب الموقع فعل إذن الموقع';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _determinePosition,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CustomColors.customWhite,
          border: Border.all(color: CustomColors.customWhite),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: CustomColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(_locationText, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
