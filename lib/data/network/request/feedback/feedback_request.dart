// @dart = 2.9
// To parse this JSON data, do
//
//     final feedbackRequest = feedbackRequestFromJson(jsonString);

import 'dart:convert';

FeedbackRequest feedbackRequestFromJson(String str) => FeedbackRequest.fromJson(json.decode(str));

String feedbackRequestToJson(FeedbackRequest data) => json.encode(data.toJson());

class FeedbackRequest {
  FeedbackRequest({
    this.name,
    this.feedback,
    this.hasImage,
    this.authToken,
  });

  String name;
  String feedback;
  bool hasImage;
  String authToken;

  factory FeedbackRequest.fromJson(Map<String, dynamic> json) => FeedbackRequest(
    name: json["Name"] == null ? null : json["Name"],
    feedback: json["Feedback"] == null ? null : json["Feedback"],
    hasImage: json["HasImage"] == null ? null : json["HasImage"],
    authToken: json["AuthToken"] == null ? null : json["AuthToken"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "Feedback": feedback == null ? null : feedback,
    "HasImage": hasImage == null ? null : hasImage,
    "AuthToken": authToken == null ? null : authToken,
  };
}
