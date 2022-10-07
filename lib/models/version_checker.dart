import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pom/extensions/translation_helper.dart';
import 'package:pom/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionChecker {
  double currentVersion = 0;
  double minimalEnforcedVersion = 0;
  double latestVersion = 0;
  BuildContext context;

  VersionChecker(this.context);

  Future<void> init() async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    currentVersion = double.parse(info.version.trim().replaceAll('.', ''));

    //Get Latest version info from firebase config
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 0),
      ),
    );

    try {
      await remoteConfig.fetchAndActivate();

      if (Platform.isIOS) {
        minimalEnforcedVersion = double.parse(
          remoteConfig
              .getString('minimal_enforced_version_ios')
              .trim()
              .replaceAll('.', ''),
        );

        latestVersion = double.parse(
          remoteConfig
              .getString('latest_version_ios')
              .trim()
              .replaceAll('.', ''),
        );
      } else {
        minimalEnforcedVersion = double.parse(
          remoteConfig
              .getString('minimal_enforced_version_android')
              .trim()
              .replaceAll('.', ''),
        );
        latestVersion = double.parse(
          remoteConfig
              .getString('latest_version_android')
              .trim()
              .replaceAll('.', ''),
        );
      }

      if (minimalEnforcedVersion > currentVersion) {
        showVersionDialog(forceUpdate: true);
      } else if (latestVersion > currentVersion) {
        showVersionDialog();
      }
    } on Exception catch (exception) {
      // Fetch throttled.
      debugPrint(exception.toString());
    } catch (exception) {
      debugPrint(
        'Unable to fetch remote config. Cached or default values will be '
        'used',
      );
    }
  }

  showVersionDialog({bool forceUpdate = false}) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final String title = forceUpdate
            ? context.translate.forceUpdateDialogTitle
            : context.translate.updateDialogTitle;
        final String message = forceUpdate
            ? context.translate.forceUpdateDialogText
            : context.translate.updateDialogText;
        final String btnLabel = context.translate.updateDialogButton;
        final String btnLabelCancel = context.translate.updateDialogButtonLater;

        return WillPopScope(
          onWillPop: () async => false,
          child: Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text(title),
                  content: Text(message),
                  actions: <Widget>[
                    TextButton(
                      child: Text(btnLabel),
                      onPressed: () async =>
                          await launchUrl(Uri.parse(appStoreUrl)),
                    ),
                    if (!forceUpdate)
                      TextButton(
                        child: Text(btnLabelCancel),
                        onPressed: () => Navigator.pop(context),
                      ),
                  ],
                )
              : AlertDialog(
                  title: Text(title),
                  content: Text(message),
                  actions: <Widget>[
                    TextButton(
                      child: Text(btnLabel),
                      onPressed: () async =>
                          await launchUrl(Uri.parse(playStoreUrl)),
                    ),
                    if (!forceUpdate)
                      TextButton(
                        child: Text(btnLabelCancel),
                        onPressed: () => Navigator.pop(context),
                      ),
                  ],
                ),
        );
      },
    );
  }
}
