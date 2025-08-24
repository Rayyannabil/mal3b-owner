import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart'; // Required for Color in Fluttertoast

class LocationService {
  /// Determine the current position of the device and return a human-readable address.
  ///
  /// If location services are not enabled or permissions are denied,
  /// it will show a toast message and return an error string.
  Future<String> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
        msg: "خدمات الموقع غير مفعلة ، برجاء تفعيلها.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return Future.error('خدمات الموقع غير مفعلة.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
          msg: "صلاحيات الوصول إلى الموقع غير مفعلة ، برجاء تفعيلها.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return Future.error('خدمات الموقع غير مفعلة.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg: "خدمات الموقع غير مفعلة بشكل دائم ، برجاء تفعيلها من الإعدادات.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // You can customize the address format as needed
        return "${place.locality ?? ''}, ${place.country ?? ''}";
      } else {
        return "موقع غير معروف";
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "حدث خطأ في الوصول للموقع:  ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return Future.error('حدث خطأ في الوصول للموقع: ${e.toString()}');
    }
  }

  Future getLongAndLat() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
  }
}
