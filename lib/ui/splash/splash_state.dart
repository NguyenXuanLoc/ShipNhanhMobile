import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class StartSplashState extends SplashState {
  bool loggedIn = false;

  StartSplashState({this.loggedIn = false});

  @override
  String toString() => 'StartSplashState';
}

class EnterLoginState extends SplashState {}

