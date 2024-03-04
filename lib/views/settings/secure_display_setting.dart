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

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
  

// Project imports:
import 'package:securenotes/data/preference_and_config.dart';
import 'package:securenotes/models/app_theme.dart';
import 'package:securenotes/utils/styles.dart';

class SecureDisplaySetting extends StatefulWidget {
  SecureDisplaySetting({Key? key}) : super(key: key);

  @override
  State<SecureDisplaySetting> createState() => _SecureDisplaySettingState();
}

class _SecureDisplaySettingState extends State<SecureDisplaySetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Secure Display'.tr(),
          style: appBarTitle,
        ),
      ),
      body: _settings(),
    );
  }

  Widget _settings() {
    return ListView(
      children: [
            ListTile(

              title: Text('Secure Display'.tr()),
              trailing: Switch(
                value: PreferencesStorage.isFlagSecure,
                onChanged: (value) {
                  PreferencesStorage.setIsFlagSecure(value);
                  setState(() {});
                },
              ),

              subtitle: Text(
                  'When turned on, the content on the screen is treated as secure, blocking background snapshots and preventing it from appearing in screenshots or from being viewed on non-secure displays.'
                      .tr()),

        ),
      ],
    );
  }
}
