import 'package:flutter/material.dart';
import 'constants.dart';

class CheckLocationPermissionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Text title = Text('Need Location Access');
    const Center center = Center(child: Text('Checking we have location access...'));
    return MaterialApp(
      title: appName,
      home: Scaffold(
        appBar: AppBar(
          title: title
        ),
        body: center
      )
    );
  }
}

class NoLocationPermissionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Text title = Text('No Location Access');
    final AppBar appBar = AppBar(title: title);
    const Center center = Center(child: Text('You have not allowed permissions access, s the app cannot proceed.'));
    final Scaffold scaffold = Scaffold(
      appBar: appBar,
      body: center
    );
    return scaffold;
  }
}
