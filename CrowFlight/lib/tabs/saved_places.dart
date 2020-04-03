import 'package:flutter/material.dart';
import 'base.dart';

class SavedPlacesTab extends StatefulWidget {
  @override
  SavedPlacesTabState createState() => SavedPlacesTabState();
}

class SavedPlacesTabState extends State<SavedPlacesTab> {
  @override
  Widget build(BuildContext context) {
    const Center center = Center(child: Text('Saved places should show up here in a list view thingy.'));
    return center;
  }
}

final CrowFlightTab savedPlaces = CrowFlightTab('Saved Places', Icons.favorite, SavedPlacesTab());
