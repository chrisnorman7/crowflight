/// Provides the [LoadingPage] page.
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final String appTitle;
  LoadingPage(this.appTitle);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appTitle)),
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
