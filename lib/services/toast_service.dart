import 'package:flutter/material.dart';
import 'package:mal3b/components/toast_component.dart';

enum ToastType { success, error, info }

class ToastService {
  static final ToastService _instance = ToastService._internal();
  factory ToastService() => _instance;
  ToastService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  OverlayEntry? _overlayEntry;

  void showToast({required String message, required ToastType type}) {
    final overlayState = navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (_) => ToastComponent(
        message: message,
        type: type,
        onDismiss: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
      ),
    );

    overlayState.insert(_overlayEntry!);
  }
}
