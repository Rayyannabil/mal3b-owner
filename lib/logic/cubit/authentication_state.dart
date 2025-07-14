part of 'authentication_cubit.dart';

abstract class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class AuthenticationSignUpSuccess extends AuthenticationState {}

final class AuthenticationSignUpError extends AuthenticationState {
  final String msg;
  AuthenticationSignUpError({required this.msg});
}

final class AuthenticationSignInSuccess extends AuthenticationState {
  final String msg;
  AuthenticationSignInSuccess({required this.msg});
}

final class AuthenticationSignInError extends AuthenticationState {
  final String msg;
  AuthenticationSignInError({required this.msg});
}

final class AuthenticationLoggedOut extends AuthenticationState {}

final class AuthenticationLogoutError extends AuthenticationState {
  final String msg;
  AuthenticationLogoutError({required this.msg});
}

final class AccountDeletedSuccessfully extends AuthenticationState {
  final String msg;
  AccountDeletedSuccessfully({required this.msg});
}

final class AccountDeleteFailed extends AuthenticationState {
  final String msg;
  AccountDeleteFailed({required this.msg});
}

final class AccountDetailsGotSuccessfully extends AuthenticationState {
  // final UserProfileModel user;
  // AccountDetailsGotSuccessfully({required this.user});
}

final class AccountDetailsLoading extends AuthenticationState {}

final class AccountDetailsUpdateLoading extends AuthenticationState {}

final class AccountDetailsGotFailed extends AuthenticationState {
  final String msg;
  AccountDetailsGotFailed({required this.msg});
}

final class AccountDetailsUpdatedFailed extends AuthenticationState {
  final String msg;
  AccountDetailsUpdatedFailed({required this.msg});
}

final class AccountDetailsUpdatedSuccess extends AuthenticationState {}
