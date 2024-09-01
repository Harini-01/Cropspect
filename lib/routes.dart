import 'package:flutter/material.dart';
import 'capture.dart';
import 'results.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cropspect',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: CapturePage(),
      routes: {
        '/results': (context) {
          final String result = ModalRoute.of(context)?.settings.arguments as String? ?? 'No result';
          return ResultsPage(result: result);
        },
      },
    );
  }
}
