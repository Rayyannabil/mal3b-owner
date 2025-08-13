// part of 'stadium_cubit.dart';

// abstract class StadiumState {}

// class StadiumInitial extends StadiumState {}

// class StadiumLoading extends StadiumState {}

// class StadiumLoaded extends StadiumState {
//   final List<Map<dynamic, dynamic>> stadiums;
//   StadiumLoaded(this.stadiums);
// }

// class StadiumError extends StadiumState {
//   final String msg;
//   StadiumError({required this.msg});
// }

part of 'stadium_cubit.dart';

sealed class StadiumState {}

final class StadiumInitial extends StadiumState {}

final class StadiumLoading extends StadiumState {}

final class StadiumLoaded extends StadiumState {
  final List<Map<String, dynamic>> stadiums;
  StadiumLoaded(this.stadiums);
}

final class StadiumError extends StadiumState {
  final String msg;
  StadiumError({required this.msg});
}

// ====== Deletion States ======
final class StadiumDeleteLoading extends StadiumState {}

final class StadiumDeleteSuccess extends StadiumState {
  final String msg;
  StadiumDeleteSuccess({required this.msg});
}

final class StadiumDeleteError extends StadiumState {
  final String msg;
  StadiumDeleteError({required this.msg});
}

class OfferLoading extends StadiumState {}

class OfferSuccess extends StadiumState {}

class OfferError extends StadiumState {
  final String msg;
  OfferError({required this.msg});
}



