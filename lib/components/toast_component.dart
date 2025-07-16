import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mal3b/services/toast_service.dart';

class ToastComponent extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  const ToastComponent({
    super.key,
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<ToastComponent> createState() => _ToastComponentState();
}

class _ToastComponentState extends State<ToastComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;
  late Animation<double> _fade;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _offset = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(_controller);
    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    _hideTimer = Timer(Duration(seconds: 3), () {
      if (!mounted) return;
      _controller.reverse().then((_) {
        if (mounted) widget.onDismiss();
      });
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Color get _bgColor {
    switch (widget.type) {
      case ToastType.success:
        return Color(0xFFA4BE7B);
      case ToastType.error:
        return  Color(0xFFF05454); 
      case ToastType.info:
        return Color(0xFF6DA9E4);
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.info:
        return Icons.info; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _offset,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: _bgColor,
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Icon(_icon, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "MadaniArabic",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
