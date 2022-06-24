// @dart = 2.9
import 'package:smartship_partner/data/model/location_model.dart';

class Person {
  final String number;
  final String displayName;
  final String email;
  String phone;
  final String pictureUrl;
  final int userId;
  final int totalRates;
  final LocationModel location;
  double rate;

  Person(
      {this.number,
      this.displayName,
      this.email,
      this.phone,
      this.pictureUrl,
      this.userId,
      this.totalRates,
      this.location,
      this.rate = 0.0});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
      number: json['Number'],
      displayName: json['DisplayName'],
      email: json['Email'],
      phone: json['Phone'],
      pictureUrl: json['PictureUrl'],
      userId: json['UserId'],
      totalRates: json['TotalRates'],
      rate: json['Rate'] ?? 0.0,
      location: LocationModel.fromJson(json['location']));

  Map<String, dynamic> toJson() => {
        'Number': number,
        'DisplayName': displayName,
        'Email': email,
        'Phone': phone,
        'PictureUrl': pictureUrl,
        'UserId': userId,
        'TotalRates': totalRates,
        'Rate': rate,
        'location': location.toJson()
      };
}
