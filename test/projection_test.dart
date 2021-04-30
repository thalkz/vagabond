import 'dart:math';

import 'package:vagabond/models/latlng.dart';
import 'package:vagabond/utils/projection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Transform to MercatorPoint', () {
    final actual = Projection.toMercatorPoint(LatLng(49, 2));
    final expected = Point(222638.98, 6274861.39);
    expect(actual.distanceTo(expected), lessThan(0.01));
  });

  test('Transform from MercatorPoint', () {
    final actual = Projection.fromMercator(Point(222638.98, 6274861.39));
    final expected = LatLng(49, 2);
    expect((actual.latitude - expected.latitude).abs() < 0.00001, true);
    expect((actual.longitude - expected.longitude).abs() < 0.00001, true);
  });

  test('Transform to WorldPoint (top left)', () {
    final actual = Projection.toWorldPoint(LatLng(85.0511, -180));
    final expected = Point(0.0, 0.0);
    expect(actual.distanceTo(expected), lessThan(0.01));
  });

  test('Transform to WorldPoint (bottom right)', () {
    final actual = Projection.toWorldPoint(LatLng(-85.0511, 180));
    final expected = Point(256.0, 256.0);
    expect(actual.distanceTo(expected), lessThan(0.01));
  });

  test('Transform to WorldPoint (random point)', () {
    final expected = Point(65.67, 95.17);
    final actual = Projection.toWorldPoint(Projection.fromWorldPoint(expected));
    expect(actual.distanceTo(expected), lessThan(0.01));
  });

  test('Transform to TileIndex', () {
    final expected = Point(8, 11);
    final tileIndex = Projection.toTileIndex(LatLng(41.85, -87.65), zoom: 5);
    expect(
      Point(
        tileIndex.x.floor(),
        tileIndex.y.floor(),
      ),
      expected,
    );
  });
}
