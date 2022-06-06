import 'dart:io';

class SettingsModel {
  final bool isDark;
  final String locale;

  SettingsModel({
    required this.isDark,
    required this.locale,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        isDark: json['isDark'] as bool? ?? false,
        locale: json['locale'] as String? ?? Platform.localeName,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isDark': isDark,
        'locale': locale,
      };
}
