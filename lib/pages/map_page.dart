import 'dart:math';

import 'package:vagabond/models/latlng.dart';
import 'package:vagabond/utils/env.dart';
import 'package:vagabond/utils/projection.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final controller = MapController(
    location: LatLng(45.753414, 4.831531),
  );

  void _centerLocation() {
    controller.center = LatLng(45.753414, 4.831531);
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
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
      controller.zoom += 0.05;
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: _onDoubleTap,
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        onScaleEnd: (details) {
          print("Location: ${controller.center.latitude}, ${controller.center.longitude}");
        },
        child: Stack(
          children: [
            Map(
              controller: controller,
              builder: (context, x, y, z) {
                final url = 'https://tile.thunderforest.com/outdoors/$z/$x/$y.png?apikey=$thunderforestKey';
                return FadeInNetworkImage(url: url);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerLocation,
        tooltip: 'My Location',
        child: Icon(Icons.my_location),
      ),
    );
  }
}

class FadeInNetworkImage extends StatelessWidget {
  const FadeInNetworkImage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded ?? false) {
          return child;
        }
        return AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      },
    );
  }
}

typedef MapTileBuilder = Widget Function(BuildContext context, int x, int y, int z);

class Map extends StatefulWidget {
  final MapController controller;
  final MapTileBuilder builder;

  Map({
    Key? key,
    required this.builder,
    required this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final controller = widget.controller;
    final tileSize = controller.tileSize;
    final size = constraints.biggest;

    final screenWidth = size.width;
    final screenHeight = size.height;

    final centerX = screenWidth / 2.0;
    final centerY = screenHeight / 2.0;

    final scale = pow(2.0, controller._zoom);

    final norm = Projection.toTileIndex(controller._center, zoom: 0);
    final ttl = Point(norm.x * tileSize * scale, norm.y * tileSize * scale);

    final fixedZoom = (controller._zoom).toInt();
    final fixedPowZoom = pow(2, fixedZoom);

    final centerTileIndexX = (norm.x * fixedPowZoom).floor();
    final centerTileIndexY = (norm.y * fixedPowZoom).floor();

    final scaleValue = pow(2.0, (controller._zoom % 1));
    final tileSizeScaled = tileSize * scaleValue;
    final numGrids = pow(2.0, controller._zoom).floor();

    final numTilesX = (screenWidth / tileSize / 2.0).ceil();
    final numTilesY = (screenHeight / tileSize / 2.0).ceil();

    final children = <Widget>[];

    for (int i = centerTileIndexX - numTilesX; i <= centerTileIndexX + numTilesX; i++) {
      for (int j = centerTileIndexY - numTilesY; j <= centerTileIndexY + numTilesY; j++) {
        if (i < 0 || i >= numGrids || j < 0 || j >= numGrids) {
          continue;
        }

        final ox = (i * tileSizeScaled) + centerX - ttl.x;
        final oy = (j * tileSizeScaled) + centerY - ttl.y;

        final child = Positioned(
          width: tileSizeScaled,
          height: tileSizeScaled,
          left: ox,
          top: oy,
          child: widget.builder.call(context, i, j, (controller._zoom).floor()),
        );

        children.add(child);
      }
    }

    final stack = Stack(children: children);
    return stack;
  }
}

class MapController extends ChangeNotifier {
  LatLng _center;
  double _zoom;
  double tileSize;

  MapController({
    required LatLng location,
    double zoom: 14,
    this.tileSize: 128,
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
