part of 'notification_cubit.dart';

sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationSuccess extends NotificationState {
  final List<Map<String, dynamic>> notifications;
  NotificationSuccess(this.notifications);
}

final class NotificationLoading extends NotificationState {}

final class NotificationError extends NotificationState {
  final String msg;
  NotificationError({required this.msg});
}

final class NotificationSeenChanged extends NotificationState {}
