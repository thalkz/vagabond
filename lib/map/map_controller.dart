import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vagabond/models/latlng.dart';
import 'package:vagabond/utils/projection.dart';

class MapController extends ChangeNotifier {
  LatLng _center;
  double _zoom;
  double tileSize;

  MapController({
    required LatLng location,
    double zoom: 14,
    this.tileSize: 256,
  })  : _center = location,
        _zoom = zoom;

  void drag(double dx, double dy) {
    var scale = pow(2.0, _zoom);
    final mon = Projection.toTileIndex(_center, zoom: 0);

    final delta = Point(
      (dx / tileSize) / scale,
      (dy / tileSize) / scale,
    );

    center = Projection.fromTileIndex(mon - delta, zoom: 0);
  }

  LatLng get center {
    return _center;
  }

  set center(LatLng center) {
    _center = center;
    notifyListeners();
  }

  double get zoom {
    return _zoom;
  }

  set zoom(double zoom) {
    _zoom = zoom;
    notifyListeners();
  }
}
