import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils.dart';

import 'base.dart';

class SettingsTab extends StatefulWidget {
  @override
  SettingsTabState createState() => SettingsTabState();
}

class SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = <Widget>[
      CheckboxListTile(
        title: const Text('Enable Vibration'),
        value: vibrationEnabled,
        onChanged: (bool value) {
          setState(() {
            vibrationEnabled = value;
            savePreferenceBool(vibrationEnabledPreferenceName, vibrationEnabled);
          });
        }
      ),
      Semantics(
        child: DropdownButton<int>(
          hint: const Text('Compass Style'),
          value: compassStyle,
          items: CompassStyles.values.map((CompassStyles item) {
            final int index = item.index;
            return DropdownMenuItem<int>(
              child: Text(compassStyleNames[index]),
              value: index
            );
          }).toList(),
          onChanged: (int value) {
            setState(() {
              compassStyle = value;
              savePreferenceInt(compassStylePreferenceName, compassStyle);
            });
          }
        ),
        label: 'Compass Style',
        value: compassStyleNames[compassStyle]
      )
    ];
    return ListView.builder(
      itemCount: rows.length * 2,
      itemBuilder: (BuildContext context, int index) {
        if (index.isOdd) {
          return const Divider(height: 100);
        } else {
          return rows[index ~/ 2];
        }
      }
    );
  }
}

final CrowFlightTab settings = CrowFlightTab('Settings', Icons.settings, SettingsTab());
