// @dart = 2.9
import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/network/request/feedback/feedback_request.dart';

abstract class FeedbackEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendFeedbackEvent extends FeedbackEvent {
  FeedbackRequest request;
  String filePath;

  SendFeedbackEvent([this.request, this.filePath]);

  @override
  List<Object> get props => [request];
}

/// **********************Event bus event ********************/
class EBFeedbackSent {
  bool isSuccess;

  EBFeedbackSent(this.isSuccess);
}
