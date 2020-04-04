import 'dart:async';

import 'package:flutter/material.dart';

import '../constants.dart';
import '../forms/add_saved_place.dart';
import '../saved_place.dart';
import '../utils.dart';

import 'base.dart';

class SavedPlacesTab extends StatefulWidget {
  @override
  SavedPlacesTabState createState() => SavedPlacesTabState();
}

class SavedPlacesTabState extends State<SavedPlacesTab> {
  StreamSubscription<List<SavedPlace>> _listener;

  @override
  void initState() {
    super.initState();
    _listener = savedPlacesStreamController.stream.listen((List<SavedPlace> savedPlaces) {
      setState(() => null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return FloatingActionButton(
            tooltip: 'Add',
            onPressed: () => pushRoute(context, AddSavedPlaceWidget())
          );
        }
        return Text(savedPlacesList[index - 1].title);
      },
      itemCount: savedPlacesList.length + 1
    );
  }
  
  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }
}

final CrowFlightTab savedPlaces = CrowFlightTab('Saved Places', Icons.favorite, SavedPlacesTab());
