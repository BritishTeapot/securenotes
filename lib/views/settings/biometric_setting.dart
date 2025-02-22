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
import 'package:securenotes/models/biometric_auth.dart';
import 'package:securenotes/utils/styles.dart';

class BiometricSetting extends StatefulWidget {
  BiometricSetting({Key? key}) : super(key: key);

  @override
  State<BiometricSetting> createState() => _BiometricSettingState();
}

class _BiometricSettingState extends State<BiometricSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Biometric'.tr(),
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

              title: Text('Enable biometric authentication'.tr()),
              trailing: Switch(
                value: PreferencesStorage.isBiometricAuthEnabled,
                onChanged: (value) {
                  if (value)
                    BiometricAuth.enable();
                  else
                    BiometricAuth.disable();

                  setState(() {});
                },
              ),

              subtitle: Text(
                "Users are advised to assess their threat perception before enabling biometric authentication. Don't enable this if you're storing state secrets! Visit FAQs for more information."
                    .tr(),
              ),
            ),


      ],
    );
  }
}
