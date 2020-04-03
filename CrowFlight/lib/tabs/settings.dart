import 'package:flutter/material.dart';
import 'base.dart';

class SettingsTab extends StatefulWidget {
  @override
  SettingsTabState createState() => SettingsTabState();
}

class SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    const Center center = Center(child: Text('Todo: Create settings page.'));
    return center;
  }
}

final CrowFlightTab settings = CrowFlightTab('Settings', Icons.settings, SettingsTab());
