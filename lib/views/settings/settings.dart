/*
* Copyright (C) Keshav Priyadarshi and others - All Rights Reserved.
*
* SPDX-License-Identifier: GPL-3.0-or-later
* You may use, distribute and modify this code under the
* terms of the GPL-3.0+ license.
*
* You should have received a copy of the GNU General Public License v3.0 with
* this file. If not, please visit https://www.gnu.org/licenses/gpl-3.0.html
*
* See https://safenotes.dev for support or download.
*/

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:securenotes/dialogs/biometric_auth_disclaimer.dart';

// Project imports:
import 'package:securenotes/models/biometric_auth.dart';
import 'package:securenotes/data/preference_and_config.dart';
import 'package:securenotes/dialogs/backup_import.dart';
import 'package:securenotes/dialogs/generic.dart';
import 'package:securenotes/models/app_theme.dart';
import 'package:securenotes/models/session.dart';
import 'package:securenotes/utils/styles.dart';
import 'package:securenotes/utils/url_launcher.dart';
import 'package:securenotes/widgets/dark_mode.dart';
import 'package:securenotes/widgets/footer.dart';

class SettingsScreen extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;

  SettingsScreen({Key? key, required this.sessionStateStream})
      : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings'.tr(),
          style: appBarTitle,
        ),
      ),
      body: _settings(),
    );
  }

  Widget _settings() {
    return ListView(
      children: [
        //Divider(),
        _category_header('General'),
        ListTile(
          leading: Icon(MdiIcons.arrowCollapseVertical),
          title: Text('Compact Notes'.tr()),
          trailing: Switch(
            value: PreferencesStorage.isCompactPreview,
            onChanged: (bool value) {
              PreferencesStorage.setIsCompactPreview(value);
              setState(() {});
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.dark_mode_outlined),
          title: Text('Dark Mode'.tr()),
          trailing: Switch(
            value: PreferencesStorage.isThemeDark,
            onChanged: (_) {
              darkModalBottomSheet(context);
              setState(() {});
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.screen_rotation_outlined),
          title: Text('Auto Rotate'.tr()),
          trailing: Switch(
            value: PreferencesStorage.isAutoRotate,
            onChanged: (value) {
              PreferencesStorage.setIsAutoRotate(value);
              showGenericDialog(
                  context: context,
                  icon: Icons.restart_alt,
                  message: 'Close and open app for change to take effect'.tr()
              );
              setState(() {});
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.format_paint_outlined),
          // leading: Icon(Icons.format_paint),
          title: Text('Notes Color'.tr()),
          subtitle: !PreferencesStorage.isColorful
              ? Text('Off'.tr())
              : Text('On'.tr()),
          trailing: Icon(Icons.navigate_next),
          onTap: () async {
            await Navigator.pushNamed(context, '/chooseColorSettings');
            setState(() {});
          },
        ),
        ListTile(
          leading: Icon(Icons.language_outlined),
          title: Text('Language'.tr() +
              ((context.locale.toString() != 'en_US') ? " - Language" : "")),
          subtitle:
              Text(SafeNotesConfig.mapLocaleName[context.locale.toString()]!),
          trailing: Icon(Icons.navigate_next),
          onTap: () async {
            await Navigator.pushNamed(context, '/chooseLanguageSettings');
            setState(() {});
          },
        ),
        ListTile(
          leading: Icon(Icons.backup_outlined),
          title: Text('Backup'.tr()),
          subtitle: PreferencesStorage.isBackupOn
              ? Text('On'.tr())
              : Text('Off'.tr()),
          trailing: Icon(Icons.navigate_next),
          onTap: () async {
            await Navigator.pushNamed(context, '/backup');
            setState(() {});
          },
        ),
        ListTile(
          leading: Icon(MdiIcons.fileDownloadOutline),
          title: Text('Import Backup'.tr()),
          onTap: () async {
            await showImportDialog(context);
          },
        ),
        Divider(),
        _category_header('Security'),
        ListTile(
          leading: Icon(MdiIcons.fingerprint),
          title: Text('Biometric'.tr()),
          trailing: Switch(
              value: PreferencesStorage.isBiometricAuthEnabled,
              onChanged: (value) async {
                if (value) {
                  if (await showDialog<bool>(context: context,
                      builder: (BuildContext context) {
                        return BiometricAuthDisclaimer();
                      }) == true)
                    BiometricAuth.enable();
                }
                else {
                  BiometricAuth.disable();
                }
                setState(() {});
              },)
        ),
        ListTile(
          leading: Icon(Icons.phonelink_lock),
          title: Text('Secure Display'.tr()),
          subtitle: Text(
              'When turned on, the content on the screen is treated as secure, blocking background snapshots and preventing it from appearing in screenshots or from being viewed on non-secure displays.'
                  .tr()),
          trailing: Switch(
            value: PreferencesStorage.isFlagSecure,
            onChanged: (value) {
              PreferencesStorage.setIsFlagSecure(value);
              showGenericDialog(
                  context: context,
                  icon: Icons.restart_alt,
                  message: 'Close and open app for change to take effect'.tr()
              );
              setState(() {});
            },
          ),
        ),
        ListTile(
          leading: Icon(MdiIcons.incognito),
          title: Text('Incognito Keyboard'.tr()),
          trailing: Switch(
            value: PreferencesStorage.keyboardIncognito,
            onChanged: (bool value) {
              PreferencesStorage.setKeyboardIncognito(
                  !PreferencesStorage.keyboardIncognito);
              setState(() {});
            },
          ),
        ),
        ListTile(
            leading: Icon(MdiIcons.cellphoneKey),
            title: Text('Logout on Inactivity'.tr()),
            subtitle: Text(inactivityTimeoutValue()),
            trailing: Icon(Icons.navigate_next),
            onTap: () async {
              await Navigator.pushNamed(context, '/inactivityTimerSettings');
              setState(() {});
            }),
        ListTile(
          title: Text('Change Passphrase'.tr()),
          leading: Icon(Icons.lock_outline),
          // leading: Icon(Icons.lock),
          onTap: () async {
            await Navigator.pushNamed(context, '/changepassphrase');
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'.tr()),
          onTap: () async {
            Session.logout();
            widget.sessionStateStream.add(SessionState.stopListening);
            await Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (Route<dynamic> route) => false,
              arguments: SessionArguments(
                sessionStream: widget.sessionStateStream,
                isKeyboardFocused: false,
              ),
            );
          },
        ),
        Divider(),
        _category_header('Miscellaneous'),
        ListTile(
          leading: Icon(Icons.rate_review_outlined),
          title: Text('Rate Us'.tr()),
          onTap: () async {
            String playstoreUrl = SafeNotesConfig.playStoreUrl;
            try {
              await launchUrlExternal(Uri.parse(playstoreUrl));
            } catch (e) {}
          },
        ),
        ListTile(
          leading: Icon(MdiIcons.frequentlyAskedQuestions),
          title: Text('FAQs'.tr()),
          onTap: () async {
            String faqsUrl = SafeNotesConfig.FAQsUrl;
            try {
              await launchUrlExternal(Uri.parse(faqsUrl));
            } catch (e) {}
          },
        ),
        ListTile(
          leading: Icon(MdiIcons.github),
          title: Text('Source Code'.tr()),
          onTap: () async {
            String sourceCodeUrl = SafeNotesConfig.githubUrl;
            try {
              await launchUrlExternal(Uri.parse(sourceCodeUrl));
            } catch (e) {}
          },
        ),
        ListTile(
          leading: Icon(Icons.mail_outline),
          title: Text('Email'.tr()),
          onTap: () async {
            String email = SafeNotesConfig.mailToForFeedback;
            try {
              await launchUrlExternal(Uri.parse(email));
            } catch (e) {}
          },
        ),
        ListTile(
          leading: Icon(Icons.collections_bookmark_outlined),
          title: Text('Open Source license'.tr()),
          onTap: () async {
            String license = SafeNotesConfig.openSourceLicense;
            try {
              await launchUrlExternal(Uri.parse(license));
            } catch (e) {}
          },
        ),
        Padding(padding: EdgeInsets.only(top: 20), child: footer()),
      ],
    );
  }

  /*Future<void> showReopenAppDialog(BuildContext context,
      {VoidCallback? homeRefresh}) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Close and open app for change to take effect'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }*/

  Widget _category_header(String text) {
    return ListTile(
      dense: true,
      title: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  String inactivityTimeoutValue() {
    var index = PreferencesStorage.inactivityTimeoutIndex;
    List<int> values = [30, 1, 2, 3, 5, 10, 15];
    if (index < 1) return '${values[index]} sec';
    return '${values[index]} min';
  }
}
