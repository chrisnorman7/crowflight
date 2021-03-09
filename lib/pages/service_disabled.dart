/// Provides the [ServiceDisabledPage] page.
import 'package:flutter/material.dart';

class ServiceDisabledPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Service Disabled'),
        ),
        body: Center(
          child: Text(
              'The GPS service is disabled. You must re-enable it before this app will work.'),
        ),
      );
}
