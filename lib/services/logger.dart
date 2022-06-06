import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class Logger {
  void record({
    required dynamic error,
    required StackTrace stack,
    String? reason,
  }) {
    debugPrintStack(label: error?.toString() ?? 'Exception', stackTrace: stack);

    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      FirebaseCrashlytics.instance.recordError(error, stack, reason: reason);
    }
  }
}
