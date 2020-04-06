import 'package:flutter/material.dart';
import 'package:location/location.dart';

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
      ListTile(
        title: const Text('Compass Style'),
        trailing: DropdownButton<CompassStyle>(
          hint: const Text('Compass Style'),
          value: compassStyle,
          items: compassStyles.entries.map((MapEntry<CompassStyle,String> entry) {
            return DropdownMenuItem<CompassStyle>(
              child: Text(entry.value),
              value: entry.key
            );
          }).toList(),
          onChanged: (CompassStyle value) {
            setState(() {
              compassStyle = value;
              savePreferenceInt(compassStylePreferenceName, compassStyle.index);
            });
          }
        )
      ),
      ListTile(
        title: const Text('GPS Accuracy'),
        trailing: DropdownButton<LocationAccuracy>(
          hint: const Text('GPS Accuracy'),
          value: gpsAccuracy,
          items: gpsAccuracies.entries.map((MapEntry<LocationAccuracy,String> entry) {
            return DropdownMenuItem<LocationAccuracy>(
              child: Text(entry.value),
              value: entry.key
            );
          }).toList(),
          onChanged: (LocationAccuracy value) {
            setState(() {
              gpsAccuracy = value;
              changeGpsAccuracy(value);
              savePreferenceInt(gpsAccuracyPreferenceName, value.index);
            });
          }
        )
      ),
      ListTile(
        title: const Text('Length of vibrations (in milliseconds) felt after arrival'),
        subtitle: const Text('No less than 10'),
        trailing: Container(
          width: 100,
          child:TextField(
            maxLength: 3,
            keyboardType: const TextInputType.numberWithOptions(),
            controller: TextEditingController(text: arrivedVibrationDuration.toString()),
            onChanged: (String value) {
              if (value.isNotEmpty == true) {
                final int n = int.tryParse(value);
                if (n != null && n >= 10) {
                  arrivedVibrationDuration = n;
                  savePreferenceInt(arrivedVibrationDurationPreferenceName, arrivedVibrationDuration);
                }
              }
            }
          )
        )
      ),
      ListTile(
        title: const Text('Length of vibrations (in milliseconds) felt while approaching destination'),
        subtitle: const Text('No less than 10'),
        trailing: Container(
          width: 100,
          child:TextField(
            maxLength: 3,
            keyboardType: const TextInputType.numberWithOptions(),
            controller: TextEditingController(text: movingVibrationDuration.toString()),
            onChanged: (String value) {
              if (value.isNotEmpty == true) {
                final int n = int.tryParse(value);
                if (n != null && n >= 10) {
                  movingVibrationDuration = n;
                  savePreferenceInt(movingVibrationDurationPreferenceName, movingVibrationDuration);
                }
              }
            }
          )
        )
      ),
      ListTile(
        title: const Text('Number to multiply the distance by to determine time between vibrations'),
        subtitle: const Text('No less than 1'),
        trailing: Container(
          width: 100,
          child:TextField(
            maxLength: 4,
            keyboardType: const TextInputType.numberWithOptions(),
            controller: TextEditingController(text: distanceMultiplier.toString()),
            onChanged: (String value) {
              if (value.isNotEmpty == true) {
                final int n = int.tryParse(value);
                if (n != null && n >= 1) {
                  distanceMultiplier = n;
                  savePreferenceInt(distanceMultiplierPreferenceName, distanceMultiplier);
                }
              }
            }
          )
        )
      ),
      ListTile(
        title: const Text('Milliseconds between vibrations'),
        subtitle: const Text('No less than 100'),
        trailing: Container(
          width: 100,
          child:TextField(
            maxLength: 3,
            keyboardType: const TextInputType.numberWithOptions(),
            controller: TextEditingController(text: vibrateInterval.toString()),
            onChanged: (String value) {
              if (value.isNotEmpty == true) {
                final int n = int.tryParse(value);
                if (n != null && n >= 100) {
                  vibrateInterval = n;
                  savePreferenceInt(vibrateIntervalPreferenceName, vibrateInterval);
                }
              }
            }
          )
        )
      ),
    ];
    return ListView.builder(
      itemCount: rows.length * 2,
      itemBuilder: (BuildContext context, int index) {
        if (index.isOdd) {
          return const Divider(height: 20);
        }
        return rows[index ~/ 2];
      }
    );
  }
}

final CrowFlightTab settings = CrowFlightTab('Settings', Icons.settings, SettingsTab());
