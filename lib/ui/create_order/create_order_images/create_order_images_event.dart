// @dart = 2.9
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:smartship_partner/data/model/order/new_order.dart';

abstract class CreateOrderImagesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateOrderImagesStartEvent extends CreateOrderImagesEvent {}

class RequestCreateOrderImagesEvent extends CreateOrderImagesEvent {
  NewOrder order;
  List<File> files;

  RequestCreateOrderImagesEvent(this.order, this.files);

  @override
  List<Object> get props => [DateTime.now().millisecond];
}

///***************Event Bus**********/
/// Use for updating progress in create order by images
class ProgressCreateOrderImagesEBEvent {
  int index;
  int total;
  bool success;
  String message;

  ProgressCreateOrderImagesEBEvent({this.index, this.total, this.success=true, this.message=''});
}
