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
//import 'dart:js_interop';

import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:securenotes/data/preference_and_config.dart';
import 'package:securenotes/models/app_theme.dart';
import 'package:securenotes/utils/notes_color.dart';
import 'package:securenotes/utils/styles.dart';

class ColorPallet extends StatefulWidget {
  ColorPallet({Key? key}) : super(key: key);

  @override
  State<ColorPallet> createState() => _ColorPalletState();
}

class _ColorPalletState extends State<ColorPallet> {
  var _selectedIndex = PreferencesStorage.colorfulNotesColorIndex;
  var items = allNotesColorTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes Color'.tr(),
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
          title: Text('Colorful Notes'.tr()),
          trailing: Switch(
            value: PreferencesStorage.isColorful,
            onChanged: (value) {
              final provider = Provider.of<NotesColor>(context, listen: false);
              provider.toggleColor();
              setState(() {});
            },
          ),
          subtitle: Text('Choose the note color theme from below'.tr()),
        ),
        _colourPreview(),
        Divider(),
        ..._buildColourComboList(context),
      ],
    );
  }

  Widget _colourPreview() {
    return Column(
      children: [
        iosStylePaddedCard(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _colorBox(),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _colorBox() {
    List<Widget> colorPallets = [];
    final double heightRatio = MediaQuery.of(context).size.height / 100;
    final double boxHeight = heightRatio * 5;
    final double radius = 20;
    var first = BorderRadius.horizontal(left: Radius.circular(radius));
    var last = BorderRadius.horizontal(right: Radius.circular(radius));
    var colors = items[_selectedIndex].colorList;

    colorPallets.add(
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: colors[0],
            borderRadius: first,
          ),
          height: boxHeight,
        ),
      ),
    );
    if (colors.length > 1)
      for (final color in colors.sublist(1, colors.length - 1)) {
        colorPallets.add(
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: color),
              height: boxHeight,
              //color: color,
            ),
          ),
        );
      }
    colorPallets.add(
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: colors[colors.length - 1],
            borderRadius: last,
          ),
          height: boxHeight,
        ),
      ),
    );
    return colorPallets;
  }

  Widget iosStylePaddedCard({required List<Widget> children}) {
    final double widthRatio = MediaQuery.of(context).size.width / 100;
    final double heightRatio = MediaQuery.of(context).size.height / 100;
    final double containerRadius = 30;

    return Padding(
      padding: EdgeInsets.only(
          left: widthRatio * 5, right: widthRatio * 5, bottom: heightRatio * 1),
      child: Container(
        decoration: PreferencesStorage.isThemeDark
            ? BoxDecoration(
                color: AppThemes.darkSettingsCanvas,
                borderRadius: BorderRadius.circular(containerRadius),
              )
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(containerRadius),
              ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildColourComboList(BuildContext context) {
    return
        List.generate(
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
        title: Text(prefix.tr()),
        subtitle: helper != null
            ? Text(
                helper.tr(),
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        trailing: Radio(
            groupValue: PreferencesStorage.colorfulNotesColorIndex,
            value: index,
            onChanged: (_) {
              PreferencesStorage.setColorfulNotesColorIndex(index);
              setState(() {_selectedIndex = index;});
            },
            )
    );
  }
}
