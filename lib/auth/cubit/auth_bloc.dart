import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:tribe_quest/auth/auth.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(Uninitialized());

  final AuthenticationService _authService = GetIt.instance.get<AuthenticationService>();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is SignOut) {
      yield* _mapSignOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final userId = _authService.currentUserId;
      yield userId == null ? Unauthenticated() : Authenticated(userId);
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapSignOutToState() async* {
    try {
      await _authService.logOut();
      final userId = _authService.currentUserId;
      yield userId == null ? Unauthenticated() : Authenticated(userId);
    } catch (_) {
      yield Unauthenticated();
    }
  }
}

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  const Authenticated(this.userId);

  final String userId;

  @override
  List<Object> get props => [userId];
}

class Unauthenticated extends AuthenticationState {}

abstract class AuthenticationEvent extends Equatable {}

class AppStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class SignOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
