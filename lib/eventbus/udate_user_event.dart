// @dart = 2.9
import 'package:equatable/equatable.dart';

class UpdateUserEvent extends Equatable {
  @override
  List<Object> get props => [];

  String message;
  bool updateSuccess;

  UpdateUserEvent({this.updateSuccess, this.message=''});
}