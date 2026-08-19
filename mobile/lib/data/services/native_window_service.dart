import 'package:flutter/services.dart';

class NativeWindowService {
  NativeWindowService._();

  static const MethodChannel _channel =
      MethodChannel('dev.abrah.karter/window');

  static Future<bool> showWindowMenu() async {
    try {
      final shown = await _channel.invokeMethod<bool>('showWindowMenu');
      return shown ?? false;
    } on PlatformException {
      return false;
    }
  }
}
