import 'package:flutter/foundation.dart';

void debugPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}