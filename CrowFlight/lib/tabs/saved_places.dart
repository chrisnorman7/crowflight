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
    _listener = savedPlacesStreamController.stream
        .listen((List<SavedPlace> savedPlaces) {
      setState(() {
        saveSavedPlaces();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const String rename = 'Rename';
    const String delete = 'Delete';
    const List<String> menuItems = <String>[rename, delete];
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return FloatingActionButton(
                tooltip: 'Add',
                onPressed: () => pushRoute(context, AddSavedPlaceWidget()));
          }
          index -= 1;
          final SavedPlace place = savedPlacesList[index];
          return ListTile(
              title: Text(place.title),
              subtitle: Text('${place.latitude},${place.longitude}'),
              onTap: () {
                final SavedPlace place = savedPlacesList[index];
                coordinates.savedLatitude = place.latitude;
                coordinates.savedLongitude = place.longitude;
                coordinates.targetName = place.title;
                DefaultTabController.of(context).animateTo(1);
              },
              trailing:
                  PopupMenuButton<String>(itemBuilder: (BuildContext context) {
                return menuItems.map((String title) {
                  return PopupMenuItem<String>(
                      child: Text(title), value: title);
                }).toList();
              }, onSelected: (String result) {
                switch (result) {
                  case rename:
                    renameSavedPlace(context, place);
                    break;
                  case delete:
                    deleteSavedPlace(context, place);
                    break;
                  default:
                    throw 'Unknown result: $result.';
                }
              }));
        },
        itemCount: savedPlacesList.length + 1);
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  Future<void> renameSavedPlace(BuildContext context, SavedPlace place) {
    final TextEditingController controller = TextEditingController();
    controller.text = place.title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Rename ${place.title}.'),
              content: SingleChildScrollView(
                  child: ListBody(children: <Widget>[
                TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        labelText: 'New Title',
                        hintText: 'The new name for ${place.title}'))
              ])),
              actions: <Widget>[
                FlatButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop()),
                FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        place.title = controller.text;
                        updateSavedPlaces();
                        Navigator.of(context).pop();
                      }
                    })
              ]);
        });
  }

  Future<void> deleteSavedPlace(BuildContext context, SavedPlace place) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Delete'),
              content: SingleChildScrollView(
                  child: ListBody(children: <Widget>[
                Text('Are you sure you want to delete ${place.title}?'),
              ])),
              actions: <Widget>[
                FlatButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop()),
                FlatButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      savedPlacesList.remove(place);
                      updateSavedPlaces();
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }
}

final CrowFlightTab savedPlaces =
    CrowFlightTab('Saved Places', Icons.favorite, SavedPlacesTab());
