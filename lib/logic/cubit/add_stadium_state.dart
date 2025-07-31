part of 'add_stadium_cubit.dart';

@immutable
sealed class AddStadiumState {}

final class AddStadiumInitial extends AddStadiumState {}

final class AddStadiumLoading extends AddStadiumState {}

final class AddStadiumSuccess extends AddStadiumState {
  final String msg;
  AddStadiumSuccess({required this.msg});
}

final class AddStadiumError extends AddStadiumState {
  final String msg;
  AddStadiumError({required this.msg});
}
