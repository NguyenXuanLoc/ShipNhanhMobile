// @dart = 2.9
import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/model/note_item_model.dart';
import 'package:smartship_partner/data/model/user_info.dart';

abstract class NoteListState extends Equatable {

  @override
  List<Object> get props => [];
}

class NoteListUninitialized extends NoteListState {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Page loading';
}

class NoteListError extends NoteListState {
  @override
  String toString() => 'NoteListError';
}

class NoteListLoaded extends NoteListState {

  List<NoteItemModel> noteList;
  UserInfoModel userInfo;

  @override
  List<Object> get props => [noteList, userInfo];

  NoteListLoaded({this.noteList, this.userInfo});


  @override
  String toString() =>
      'NoteListPageLoaded ${noteList.length}';
}

class CreatedNote extends NoteListState {
  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'CreatedOrder';
}

class CreateNoteFail extends NoteListState {
  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'CreateNoteFailed';
}