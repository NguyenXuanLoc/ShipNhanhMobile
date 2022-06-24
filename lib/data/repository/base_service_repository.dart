// @dart = 2.9
import 'package:smartship_partner/data/repository/config_repository.dart';

abstract class BaseServiceRepository {
//  BaseResponse convertException<T>(dynamic ex) {
//    if (ex is SocketException) {
//      return BaseResponse<T>.of(
//          IplaError.of(ex.osError.errorCode, 'Brak połączenia z Internetem'));
//    }
//    return BaseResponse<T>.of(IplaError.of(0, 'Próba nie powiodła się'));
//  }
  Future<String> getAppKeyHeader() async {
    return ConfigRepository.get().getXAppKey() ?? '';
  }
}
