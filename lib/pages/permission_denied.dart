/// Provides the [LocationDeniedPage] page.
import 'package:flutter/material.dart';

class LocationDeniedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Insufficient Permissions'),
        ),
        body: Center(
          child: Text(
              'You must allow this app location permission before it can function.'),
        ),
      );
}
