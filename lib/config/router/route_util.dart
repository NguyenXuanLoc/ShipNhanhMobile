import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:smartship_partner/config/router/router.dart';

class RouterUtils {
  static push<T>(BuildContext context, String route,
      [bool isRemove = false]) async {
    T result = await AppRouter.router.navigateTo(context, route,
        transition: TransitionType.inFromRight, clearStack: isRemove);
    return result;
  }
}