import 'package:vagabond/pages/edit_shelter_page.dart';
import 'package:vagabond/pages/home_page.dart';
import 'package:vagabond/pages/map_page.dart';
import 'package:vagabond/pages/shelter_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const shelter = '/shelter';
  static const editShelter = '/editShelter';
  static const home = '/home';
  static const map = '/map';
}

class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case Routes.map:
        return MaterialPageRoute(builder: (_) => MapPage());
      case Routes.shelter:
        final shelterId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ShelterPage(shelterId: shelterId));
      case Routes.editShelter:
        final shelterId = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => EditShelterPage(shelterId: shelterId));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(body: Center(child: Text('Unknown route : ${settings.name}'))));
    }
  }
}
