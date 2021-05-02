
import 'package:flutter/material.dart';
import 'package:vagabond/map/map_controller.dart';

class MapDebugPanel extends StatefulWidget {
  const MapDebugPanel({required this.controller});

  final MapController controller;

  @override
  _MapDebugPanelState createState() => _MapDebugPanelState();
}

class _MapDebugPanelState extends State<MapDebugPanel> {

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white.withOpacity(0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('zoom=${widget.controller.zoom.toStringAsFixed(2)}'),
          Text('center=${widget.controller.center}'),
        ],
      ),
    );
  }
}