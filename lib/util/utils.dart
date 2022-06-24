import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Utils {
  static EventBus eventBus = EventBus();

  static String get googleMapKey => 'AIzaSyDOgwY3wCVByUqz8_h1WEeAWT0x_wC2tsU';

  static NumberFormat formatCurrency(BuildContext context) {
//    final currentLocale = Localizations.localeOf(context).toString();
//    var currencySymbol = '\$';
    final currentLocale = 'vi';
    var currencySymbol = 'đ';
    if (currentLocale == 'vi') {
      currencySymbol = 'đ';
    }
    return NumberFormat.currency(locale: currentLocale, symbol: currencySymbol);
  }

  static double minValue(List<double> arr) {
    var minX = arr[0];
    for (var e in arr) {
      if (e != null && minX != null && minX > e) {
        minX = e;
      }
    }
    return minX;
  }

  static double maxValue(List<double> arr) {
    var maxX = arr[0];
    for (var e in arr) {
      if (e != null && maxX != null && maxX < e) {
        maxX = e;
      }
    }
    return maxX;
  }

  static String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  static String shipFeeNote(String inputString, double baseFee,
      double baseDistance, double extraFee) {
    var result = '';
    result = inputString.replaceAll('%1', baseFee.toString());
    result = result.replaceAll('%2', baseDistance.toString());
    result = result.replaceAll('%3', extraFee.toString());
    return result;
  }
}

class LocationUtil {
  static LatLng? currentPosition;

  static DateTime? lastTimeGetCurrentLocation;

  static Future<LatLng?>? getCurrentLocation() async {
    print('load curent location');

    if (currentPosition == null ||
        lastTimeGetCurrentLocation == null ||
        (lastTimeGetCurrentLocation != null &&
            lastTimeGetCurrentLocation!.difference(DateTime.now()).inMinutes >
                15)) {
      var position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lastTimeGetCurrentLocation = DateTime.now();
      currentPosition = LatLng(position.latitude, position.longitude);
    }

    return currentPosition;
  }
}
