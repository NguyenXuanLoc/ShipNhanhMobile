// @dart = 2.9
import 'package:dio/dio.dart';
import 'package:smartship_partner/data/network/api_client.dart';
import 'package:smartship_partner/data/network/request/order/create_note_request.dart';
import 'package:smartship_partner/data/network/response/base_response.dart';
import 'package:smartship_partner/data/network/response/order/note_list_response.dart';
import 'package:smartship_partner/data/repository/base_service_repository.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';

class NoteRepository extends BaseServiceRepository {
  ApiClient _apiClient;
  UserRepository userRepository;
  static NoteRepository _instance;

  static NoteRepository get(UserRepository userRepository) {
    _instance ??= NoteRepository(userRepository);
    return _instance;
  }

  NoteRepository(UserRepository userRepository) {
    this.userRepository = userRepository;
    var dio = Dio();
    _apiClient = ApiClient(dio);
  }

  Future<BaseResponse<NoteListData>> getNoteList(int orderId) async {
    var token = await userRepository.getUserAuthToken();
    return _apiClient
        .getNoteList(await getAppKeyHeader(), orderId, token)
        .catchError((onError) {
      print('error, hoan.dv: $onError');
    });
  }

  Future<BaseResponse<dynamic>> createNote(
      NewNoteRequest request) async {
    return _apiClient.createNote(await getAppKeyHeader(), request);
  }

}