// @dart = 2.9
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/model/note_item_model.dart';
import 'package:smartship_partner/data/network/request/order/create_note_request.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/repository/note_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/ui/order/order_detail/note/note_list/note_list_event.dart';
import 'package:smartship_partner/ui/order/order_detail/note/note_list/note_list_state.dart';

class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {
  NoteRepository noteRepository;
  final userRepository = UserRepository.get(PrefsManager.get);

  NoteListBloc() : super(NoteListUninitialized()) {
    noteRepository = NoteRepository.get(userRepository);
  }

  @override
  Stream<NoteListState> mapEventToState(NoteListEvent event) async* {
    switch (event.runtimeType) {
      case NoteListFetch:
        yield NoteListUninitialized();
        var noteList = await _getNoteList((event as NoteListFetch).orderId);
        if (noteList != null) {
          yield NoteListLoaded(noteList: noteList);
        } else {
          yield NoteListError();
        }
        break;
      case CreateNote:
        var orderId = (event as CreateNote).orderId;
        var note = (event as CreateNote).note;
        var token = await userRepository.getUserAuthToken();
        var createNoteRequest =
            NewNoteRequest(orderId: orderId, notes: note, authToken: token);
        BaseResponse<Object> response =
            await noteRepository.createNote(createNoteRequest);

        if (response != null && response.isSuccess) {
          add(NoteListFetch(orderId: orderId));
        }
        break;
    }
  }

  Future<List<NoteItemModel>> _getNoteList(int orderId) async {
    var noteListResponse = await noteRepository.getNoteList(orderId);

    var noteListItem = <NoteItemModel>[];
    if (noteListResponse != null &&
        noteListResponse.isSuccess &&
        !noteListResponse.isLogout) {
      noteListItem = noteListResponse.dataResponse.orderLogs.map((noteRes) {
        return NoteItemModel(
            createdOn: noteRes.createdOn,
            notes: noteRes.notes,
            orderLogType: noteRes.orderLogType);
      }).toList();
      return noteListItem;
    } else {
      return null;
    }
  }
}
