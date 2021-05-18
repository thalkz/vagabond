import 'package:vagabond/map/map_widget.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  void _centerLocation() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerLocation,
        child: Icon(Icons.my_location),
      ),
    );
  }
}
