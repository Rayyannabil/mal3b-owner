part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationSuccess extends NotificationState{
final List<Map<dynamic, dynamic>> notifications;
  NotificationSuccess(this.notifications);
}

final class NotificationLoading extends NotificationState{
  
}
final class NotificationError extends NotificationState{
  final String msg;
  NotificationError({required this.msg});
}