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

class LanguageSetting extends StatefulWidget {
  LanguageSetting({Key? key}) : super(key: key);

  @override
  State<LanguageSetting> createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Language'.tr(),
          style: appBarTitle,
        ),
      ),
      body: _settings(),
    );
  }

  Widget _settings() {
    return ListView(
      children: [
        ..._buildLanguageList(context),
      ],
    );
  }

  List<Widget> _buildLanguageList(BuildContext context) {
    if (SafeNotesConfig.mapLocaleName.containsKey(context.locale.toString()))
      _selectedIndex = indexofLanguage(
          SafeNotesConfig.mapLocaleName[context.locale.toString()]!);

    var items = SafeNotesConfig.languageItems;

    return List.generate(
      items.length,
      (index) => buildFormRow(
        items[index].prefix,
        items[index].helper,
        index,
      ),
    );
  }

  Widget buildFormRow(String prefix, String? helper, int index) {
    return ListTile(
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
          context.setLocale(SafeNotesConfig.allLocale[prefix]!);
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

int indexofLanguage(String language) {
  for (var i = 0; i < SafeNotesConfig.languageItems.length; i++)
    if (SafeNotesConfig.languageItems[i].prefix == language) return i;
  return 0;
}
