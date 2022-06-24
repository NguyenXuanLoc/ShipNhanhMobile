import 'package:equatable/equatable.dart';

abstract class DriveInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadDriveInfoEvent extends DriveInfoEvent {
  int userId;
  int pageIndex;

  LoadDriveInfoEvent(this.userId, this.pageIndex);
}

///***********Eventbus ******************/
class LoadDriveFailedEBEvent {
  String message;

  LoadDriveFailedEBEvent(this.message);
}
