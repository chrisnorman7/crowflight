import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'GPS', icon: Icon(Icons.gps_fixed)),
                Tab(text: 'Directions', icon: Icon(Icons.directions_walk)),
                Tab(text: 'Saved Places', icon: Icon(Icons.favorite)),
                Tab(text: 'Settings', icon: Icon(Icons.settings)),
              ],
            ),
            title: Text('CrowFlight'),
          ),
          body: TabBarView(
            children: [
              Text('GPS Information'),
              Text('Directions'),
              Text('Saved Places'),
              Text('Settings'),
            ],
          ),
        ),
      ),
    );
  }
}