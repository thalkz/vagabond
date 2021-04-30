import 'package:vagabond/utils/env.dart';
import 'package:vagabond/utils/routes.dart';
import 'package:flutter/material.dart';

void main() async {
  await loadEnv();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vagabond',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.map,
      onGenerateRoute: RoutesGenerator.generateRoute,
    );
  }
}
