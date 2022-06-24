// @dart = 2.9
import 'package:equatable/equatable.dart';

abstract class NoteListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NoteListFetch extends NoteListEvent {

  int orderId;

  @override
  List<int> get props => [orderId];

  @override
  String toString() => 'NoteListFetch';

  NoteListFetch({this.orderId});
}

class CreateNote extends NoteListEvent {

  int orderId;
  String note;

  @override
  List<Object> get props => [orderId, note];

  CreateNote({this.orderId, this.note});
}