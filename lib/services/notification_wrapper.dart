import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_notify/easy_notify.dart';

class NotificationListenerWrapper extends StatefulWidget {
  final Widget child;

  const NotificationListenerWrapper({required this.child, Key? key})
    : super(key: key);

  @override
  State<NotificationListenerWrapper> createState() =>
      _NotificationListenerWrapperState();
}

class _NotificationListenerWrapperState
    extends State<NotificationListenerWrapper> {
  @override
  void initState() {
    super.initState();

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        EasyNotify.showBasicNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: notification.title ?? 'No title',
          imagePath: "assets/images/",
          body: notification.body ?? 'No body',
        );
      }
    });

    // Background (opened from tap)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        EasyNotify.showBasicNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: notification.title ?? 'No title (tap)',
          body: notification.body ?? 'No body (tap)',
        );
      }
    });

    // App launched from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        final notification = message.notification;
        if (notification != null) {
          EasyNotify.showBasicNotification(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            title: notification.title ?? 'No title (initial)',
            body: notification.body ?? 'No body (initial)',
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
