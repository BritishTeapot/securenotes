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

class InactivityTimerSetting extends StatefulWidget {
  InactivityTimerSetting({Key? key}) : super(key: key);

  @override
  State<InactivityTimerSetting> createState() => _InactivityTimerSettingState();
}

class _InactivityTimerSettingState extends State<InactivityTimerSetting> {
  var _selectedIndex = PreferencesStorage.inactivityTimeoutIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inactivity Timeout'.tr(),
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
          title: Text('Logout upon inactivity'.tr()),
          trailing: Switch(
            value: PreferencesStorage.isInactivityTimeoutOn,
            onChanged: (value) {
              PreferencesStorage.setIsInactivityTimeoutOn(value);
              setState(() {});
            },
          ),
          subtitle: Text('Close and open app for change to take effect'.tr()),
        ),
        Divider(),
        ..._buildTimeList(context)
      ],
    );
  }

  List<Widget> _buildTimeList(BuildContext context) {
    return List.generate(
      items.length,
      (index) => buildCupertinoFormRow(
        items[index].prefix,
        items[index].helper,
        index,
      ),
    );
  }

  Widget buildCupertinoFormRow(String prefix, String? helper, int index) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: ListTile(
        title: Text(prefix),
        subtitle: helper != null
            ? Text(
                helper,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        trailing: Radio(
          groupValue: _selectedIndex,
          value: index,
          onChanged: (_) {
            PreferencesStorage.setInactivityTimeoutIndex(index: index);
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class Item {
  final String prefix;
  final String? helper;
  const Item({required this.prefix, this.helper});
}

List<Item> items = [
  Item(prefix: '30 seconds'.tr(), helper: null),
  Item(prefix: '1 minute'.tr(), helper: null),
  Item(prefix: '2 minutes'.tr(), helper: null),
  Item(prefix: '3 minutes'.tr(), helper: 'Default'.tr()),
  Item(prefix: '5 minutes'.tr(), helper: null),
  Item(prefix: '10 minutes'.tr(), helper: null),
  Item(prefix: '15 minutes'.tr(), helper: null),
];
