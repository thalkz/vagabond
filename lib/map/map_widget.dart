import 'package:flutter/material.dart';
import 'package:vagabond/map/map_controller.dart';
import 'package:vagabond/map/tiles_layer.dart';

import '../utils/env.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({required this.controller});

  final MapController controller;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  void _onDoubleTap() {
    widget.controller.zoom += 0.5;
  }

  late Offset _dragStart;
  double _scaleStart = 1.0;

  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      widget.controller.zoom += 0.05;
    } else if (scaleDiff < 0) {
      widget.controller.zoom -= 0.02;
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart;
      _dragStart = now;
      widget.controller.drag(diff.dx, diff.dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: (details) {
        print("Location: ${widget.controller.center.latitude}, ${widget.controller.center.longitude}");
      },
      child: Stack(
        children: [
          TilesLayer(
            controller: widget.controller,
            urlBuilder: (x, y, z) => 'https://tile.thunderforest.com/outdoors/$z/$x/$y.png?apikey=$thunderforestKey',
          ),
        ],
      ),
    );
  }
}
