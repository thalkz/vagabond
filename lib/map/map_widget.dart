import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vagabond/map/network_image.dart';
import 'package:vagabond/utils/env.dart';
import 'package:vagabond/utils/logger.dart';
import 'package:vector_math/vector_math_64.dart' show Quad, Vector3;

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final _controller = TransformationController();
  final _zoom = 3;
  final _cellSize = 256.0;

  int get rowsCount => ((pow(2, _zoom)) - 1).toInt();

  bool _isCellVisible(int row, int column, Quad viewport) {
    return true;
  }

  Widget build(BuildContext context) {
    return InteractiveViewer.builder(
      minScale: 0.1,
      maxScale: 1000,
      // onInteractionStart: (details) {
      //   log.d(details.toString());
      // },
      // onInteractionUpdate: (details) {
      //   log.d(details.toString());
      // },
      // onInteractionEnd: (details) {
      //   log.d(details.toString());
      // },
      boundaryMargin: EdgeInsets.all(double.infinity),
      transformationController: _controller,
      builder: (context, Quad viewport) {
        final rect = axisAlignedBoundingBox(viewport);
        log.d(rect.height.toString());
        return Column(
          children: [
            for (int row = 0; row < rowsCount; row++)
              Row(
                children: [
                  for (int column = 0; column < rowsCount; column++)
                    _isCellVisible(row, column, viewport)
                        ? DebugNetworkImage(
                            url:
                                'https://tile.thunderforest.com/outdoors/$_zoom/$column/$row.png?apikey=$thunderforestKey',
                            text: '($row, $column)\nzoom=$_zoom}',
                            size: _cellSize,
                          )
                        : Container(
                            height: _cellSize,
                            width: _cellSize,
                            color: Colors.blue,
                            margin: const EdgeInsets.all(1.0),
                          )
                ],
              )
          ],
        );
      },
      // boundaryMargin: const EdgeInsets.all(100),
      // maxScale: 10,
      // minScale: 0.1,
      // child: Container(
      //   height: 1000,
      //   width: 1000,
      //   child: Image.network('https://wow.zamimg.com/uploads/blog/images/20516-afterlives-ardenweald-4k-desktop-wallpapers.jpg'),
      // ),
    );
  }
}

Rect axisAlignedBoundingBox(Quad quad) {
  double? xMin;
  double? xMax;
  double? yMin;
  double? yMax;
  for (final Vector3 point in <Vector3>[quad.point0, quad.point1, quad.point2, quad.point3]) {
    if (xMin == null || point.x < xMin) {
      xMin = point.x;
    }
    if (xMax == null || point.x > xMax) {
      xMax = point.x;
    }
    if (yMin == null || point.y < yMin) {
      yMin = point.y;
    }
    if (yMax == null || point.y > yMax) {
      yMax = point.y;
    }
  }
  return Rect.fromLTRB(xMin!, yMin!, xMax!, yMax!);
}
