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
      setState(() {
        saveSavedPlaces();
      });
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
        final SavedPlace place = savedPlacesList[index - 1];
        return ListTile(
          title: Text(place.title),
          subtitle: Text('${place.latitude},${place.longitude}'),
          onTap: () {
            final SavedPlace place = savedPlacesList[index ~/ 2];
            coordinates.savedLatitude = place.latitude;
            coordinates.savedLongitude = place.longitude;
            DefaultTabController.of(context).animateTo(1);
          }
        );
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
