// @dart = 2.9
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartship_partner/data/local/prefs/prefs_manager.dart';
import 'package:smartship_partner/data/network/request/feedback/feedback_request.dart';
import 'package:smartship_partner/data/repository/user_repository.dart';
import 'package:smartship_partner/ui/feedback/feedback.dart';
import 'package:smartship_partner/util/utils.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  UserRepository _userRepository;

  FeedbackBloc(FeedbackState initialState) : super(initialState) {
    _userRepository = UserRepository.get(PrefsManager.get);
  }

  @override
  Stream<FeedbackState> mapEventToState(FeedbackEvent event) async* {
    switch (event.runtimeType) {
      case SendFeedbackEvent:
        var request = (event as SendFeedbackEvent).request;
        var path = (event as SendFeedbackEvent).filePath;
        request.authToken = await _userRepository.getUserAuthToken();
        var result = await sendFeedback(path, request);
        Utils.eventBus.fire(EBFeedbackSent(result));
        return;
    }
  }

  Future<bool> sendFeedback(String filePath, FeedbackRequest request) async {
    try {
      File file;
      if (filePath != null && filePath.isNotEmpty) {
        file = File(filePath);
      }
      var response =  file==null ? await _userRepository.sendFeedback(request) : await _userRepository.sendFeedbackWithImage(file, request);
      return response.isSuccess;
    } catch (error) {
      return false;
    }
  }
}
