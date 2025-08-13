part of 'stadium_cubit.dart';

abstract class StadiumState {}

class StadiumInitial extends StadiumState {}

class StadiumLoading extends StadiumState {}

class StadiumLoaded extends StadiumState {
  final List<Map<dynamic, dynamic>> stadiums;
  StadiumLoaded(this.stadiums);
}

class StadiumError extends StadiumState {
  final String msg;
  StadiumError({required this.msg});
}

class OfferLoading extends StadiumState {}

class OfferSuccess extends StadiumState {}

class OfferError extends StadiumState {
  final String msg;
  OfferError({required this.msg});
}



