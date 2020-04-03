import 'package:flutter/material.dart';
import 'base.dart';

class DirectionsTab extends StatefulWidget {
  @override
  DirectionsTabState createState() => DirectionsTabState();
}

class DirectionsTabState extends State<DirectionsTab> {
  @override
  Widget build(BuildContext context) {
    const Center center = Center(child: Text('Directions will appear here.'));
    return center;
  }
}

final CrowFlightTab directions = CrowFlightTab('Directions', Icons.directions_walk, DirectionsTab());
