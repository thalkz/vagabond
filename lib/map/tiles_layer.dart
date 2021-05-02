import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vagabond/map/network_image.dart';
import 'package:vagabond/map/map_controller.dart';

import '../utils/projection.dart';

typedef TileUrlBuilder = String Function(int x, int y, int z);

const DEBUG_MODE = true;

class TilesLayer extends StatefulWidget {
  TilesLayer({required this.urlBuilder, required this.controller});

  final MapController controller;
  final TileUrlBuilder urlBuilder;

  @override
  State<StatefulWidget> createState() => _TilesLayerState();
}

class _TilesLayerState extends State<TilesLayer> {
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

    final scale = pow(2.0, controller.zoom);

    final norm = Projection.toTileIndex(controller.center, zoom: 0);
    final ttl = Point(norm.x * tileSize * scale, norm.y * tileSize * scale);

    final fixedZoom = (controller.zoom).toInt();
    final fixedPowZoom = pow(2, fixedZoom);

    final centerTileIndexX = (norm.x * fixedPowZoom).floor();
    final centerTileIndexY = (norm.y * fixedPowZoom).floor();

    final scaleValue = pow(2.0, (controller.zoom % 1));
    final tileSizeScaled = tileSize * scaleValue;
    final numGrids = pow(2.0, controller.zoom).floor();

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
        final url = widget.urlBuilder.call(i, j, (controller.zoom).floor());

        final child = Positioned(
          width: tileSizeScaled,
          height: tileSizeScaled,
          left: ox,
          top: oy,
          child: DEBUG_MODE
              ? DebugNetworkImage(url: url, text: '($i, $j)\nzoom=${(controller.zoom).floor()}')
              : FadeInNetworkImage(url: url),
        );

        children.add(child);
      }
    }

    final stack = Stack(children: children);
    return stack;
  }
}
