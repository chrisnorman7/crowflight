/// Provides the [NavigatePage] page.
import 'package:flutter/material.dart';

import '../json/settings.dart';
import '../util.dart';
import 'poi_page.dart';

class NavigatePage extends StatefulWidget {
  final Settings settings;

  NavigatePage(this.settings);

  @override
  NavigatePageState createState() => NavigatePageState();
}

class NavigatePageState extends State<NavigatePage> {
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _nameController =
      TextEditingController(text: 'Untitled place');
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Enter Coordinates'),
          actions: [
            IconButton(
              icon: Icon(Icons.navigation),
              tooltip: 'Navigate',
              onPressed: () {
                if (_formState.currentState?.validate() == true) {
                  final PointOfInterest poi = PointOfInterest(
                      name: _nameController.text,
                      latitude: double.parse(_latitudeController.text),
                      longitude: double.parse(_longitudeController.text),
                      accuracy: 5.0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PoiPage(widget.settings, poi)));
                }
              },
            )
          ],
        ),
        body: Form(
          key: _formState,
          child: ListView(
            children: [
              ListTile(
                title: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: nameValidator,
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(labelText: 'Latitude coordinate'),
                  validator: doubleValidator,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                ),
              ),
              ListTile(
                  title: TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'Longitude coordinate'),
                validator: doubleValidator,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ))
            ],
          ),
        ));
  }
}
