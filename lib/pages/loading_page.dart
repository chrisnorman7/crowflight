/// Provides the [LoadingPage] page.
import 'package:flutter/material.dart';

/// Show loading progress.
class LoadingPage extends StatelessWidget {
  /// Create a loading page.
  const LoadingPage(this.appTitle);

  /// The title of the application.
  final String appTitle;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(appTitle)),
        body: Center(
          child: Text('Loading...'),
        ),
      );
}
