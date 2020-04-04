import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../saved_place.dart';
import '../utils.dart';

class AddSavedPlaceWidget extends StatefulWidget {
  @override
  AddSavedPlaceWidgetState createState() => AddSavedPlaceWidgetState();
}

class AddSavedPlaceWidgetState extends State<AddSavedPlaceWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'Add saved place form');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController(text: coordinates.latitude == null? '' : coordinates.latitude.toString());
  final TextEditingController _longitudeController = TextEditingController(text: coordinates.longitude == null? '' : coordinates.longitude.toString());

  @override
  void dispose() {
    for (final TextEditingController controller in <TextEditingController>[
      _titleController,
      _latitudeController,
      _longitudeController
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const TextInputType coordinatesKeyboardType = TextInputType.numberWithOptions(decimal: true);
    String coordinateValidator(String value) {
      if (num.tryParse(value) == null) {
        return 'You must enter a valid coordinate';
      }
      return null;
    }
    return Scaffold (
      appBar: AppBar(
        title: const Text('Add a Saved Place'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'The title of your saved place'
              ),
              textCapitalization: TextCapitalization.sentences,
              controller: _titleController,
              validator: (String value) {
                if (value.isEmpty == true) {
                  return 'Saved places must have a title';
                }
                return null;
              }
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Latitude',
                hintText: 'Latitude coordinate'
              ),
              keyboardType: coordinatesKeyboardType,
              controller: _latitudeController,
              validator: coordinateValidator
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Longitude',
                hintText: 'Longitude coordinate'
              ),
              keyboardType: coordinatesKeyboardType,
              controller: _longitudeController,
              validator: coordinateValidator
            ),
            RaisedButton(
              child: const Text('Add'),
              onPressed: () {
                if (_formKey.currentState.validate() == true) {
                  final SavedPlace place = SavedPlace(
                    double.parse(_latitudeController.text),
                    double.parse(_longitudeController.text),
                    _titleController.text
                  );
                  savedPlacesList.add(place);
                  updateSavedPlaces();
                  Navigator.pop(context);
                }
              }
            )
          ]
        )
      )
    );
  }
}
