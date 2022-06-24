// @dart = 2.9
// To parse this JSON data, do
//
//     final newNoteRequest = newNoteRequestFromJson(jsonString);

import 'dart:convert';

NewNoteRequest newNoteRequestFromJson(String str) => NewNoteRequest.fromJson(json.decode(str));

String newNoteRequestToJson(NewNoteRequest data) => json.encode(data.toJson());

class NewNoteRequest {
  NewNoteRequest({
    this.notes,
    this.orderId,
    this.authToken,
  });

  String notes;
  int orderId;
  String authToken;

  factory NewNoteRequest.fromJson(Map<String, dynamic> json) => NewNoteRequest(
    notes: json["Notes"],
    orderId: json["OrderId"],
    authToken: json["AuthToken"],
  );

  Map<String, dynamic> toJson() => {
    "Notes": notes,
    "OrderId": orderId,
    "AuthToken": authToken,
  };
}