import 'package:vagabond/map/map_controller.dart';
import 'package:vagabond/map/map_debug_panel.dart';
import 'package:vagabond/map/map_widget.dart';
import 'package:flutter/material.dart';

import '../models/latlng.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _controller = MapController(location: LatLng(45.753414, 4.831531));

  void _centerLocation() {
    _controller.center = LatLng(45.753414, 4.831531);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            controller: _controller,
          ),
          SafeArea(
            child: MapDebugPanel(controller: _controller),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerLocation,
        child: Icon(Icons.my_location),
      ),
    );
  }
}
