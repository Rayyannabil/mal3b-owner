part of 'bookings_cubit.dart';

abstract class BookingsState {}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<Map<dynamic, dynamic>> bookings;
  BookingsLoaded(this.bookings);
}

class BookingsError extends BookingsState {
  final String msg;
  BookingsError({required this.msg});
}
