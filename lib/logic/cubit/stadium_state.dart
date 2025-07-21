part of 'stadium_cubit.dart';

abstract class StadiumState {}

class StadiumInitial extends StadiumState {}

class StadiumLoading extends StadiumState {}

/// Combined state for loading all stadium data at once
class StadiumAllLoaded extends StadiumState {
  final List<dynamic> allStadiums;
  final List<dynamic> nearestStadiums;
  final List<dynamic> topRatedStadiums;

  StadiumAllLoaded({
    required this.allStadiums,
    required this.nearestStadiums,
    required this.topRatedStadiums,
  });
}

/// Optional separate states if you still want to use them individually
class StadiumLoaded extends StadiumState {
  final List<dynamic> stadiums;
  StadiumLoaded(this.stadiums);
}

class NearestStadiumsLoaded extends StadiumState {
  final List<dynamic> nearestStadiums;
  NearestStadiumsLoaded(this.nearestStadiums);
}

class TopRatedStadiumsLoaded extends StadiumState {
  final List<dynamic> topRatedStadiums;
  TopRatedStadiumsLoaded(this.topRatedStadiums);
}

class StadiumError extends StadiumState {
  final String message;
  StadiumError(this.message);
}
