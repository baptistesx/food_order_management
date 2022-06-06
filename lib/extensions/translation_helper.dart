// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
extension TranslationHelper on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this)!;
}
