import 'dart:math';

import 'package:latlong2/latlong.dart';

class Projection {
  static final double earthRadius = 6378137.0;
  static final double degToRad = pi / 180.0;
  static final double radToDeg = 180.0 / pi;

  static Point toTileIndex(LatLng latlng, {required double zoom}) {
    final lat = latlng.latitude;
    final lng = latlng.longitude;

    assert(0 <= zoom && zoom <= 24);
    assert(-85.0511 <= lat && lat <= 85.0511);
    assert(-180.0 <= lng && lng <= 180.0);

    final x = (lng + 180.0) / 360.0;
    final y = 0.5 - log(tan((lat * degToRad / 2) + (pi / 4))) / (2 * pi);

    return Point(
      x * pow(2, zoom),
      y * pow(2, zoom),
    );
  }

  static LatLng fromTileIndex(Point tileIndex, {required double zoom}) {
    final x = tileIndex.x;
    final y = tileIndex.y;

    assert(0 <= zoom && zoom <= 24);
    assert(0.0 <= x && x <= pow(2, zoom));
    assert(0.0 <= y && y <= pow(2, zoom));

    final xx = x - 0.5;
    final yy = 0.5 - y;

    final lat = 90.0 - 360.0 * atan(exp(-yy * 2.0 * pi)) / pi;
    final lng = 360.0 * xx;

    return LatLng(
      lat / pow(2, zoom),
      lng / pow(2, zoom),
    );
  }

  // WorldPoint Projection
  // Reference: https://developers.google.com/maps/documentation/javascript/coordinates
  // Projected bounds: (0.0, 256.0) to (256.0, 0.0)
  // WGS84 bounds: (-180.0, -85.0511) to (180.0, 85.0511)

  static Point toWorldPoint(LatLng latlng) {
    return toPixelPoint(latlng, zoom: 0);
  }

  static LatLng fromWorldPoint(Point worldPoint) {
    return fromPixelPoint(worldPoint, zoom: 0);
  }

  // PixelPoint Projection
  // Reference: https://developers.google.com/maps/documentation/javascript/coordinates
  // pixelPoint = worldPoint * pow(2, zoom)

  static Point toPixelPoint(LatLng latlng, {required double zoom}) {
    final tileIndex = toTileIndex(latlng, zoom: zoom);

    return Point(
      tileIndex.x * 256.0,
      tileIndex.y * 256.0,
    );
  }

  static LatLng fromPixelPoint(Point pixelPoint, {required double zoom}) {
    final tileIndex = Point(
      pixelPoint.x / 256.0,
      pixelPoint.y / 256.0,
    );

    return fromTileIndex(tileIndex, zoom: zoom);
  }

  // Pseudo-Mercator Projection
  // Reference: https://epsg.io/3857
  // Projected bounds: (-20026376.39, -20048966.10) to (20026376.39, 20048966.10)
  // WGS84 bounds: (-180.0, -85.0511) to (180.0, 85.0511)

  static Point toMercatorPoint(LatLng latlng) {
    final lng = latlng.longitude;
    final lat = latlng.latitude;

    assert(-85.0511 <= lat && lat <= 85.0511);
    assert(-180.0 <= lng && lng <= 180.0);

    return Point(
      lng * degToRad * earthRadius,
      log(tan(lat * degToRad / 2 + pi / 4)) * earthRadius,
    );
  }

  static LatLng fromMercator(Point mercatorPoint) {
    final x = mercatorPoint.x;
    final y = mercatorPoint.y;

    assert(-20026376.39 <= x && x <= 20026376.39);
    assert(-20048966.10 <= y && y <= 20048966.10);

    return LatLng(
      (2 * atan(exp(y / earthRadius)) - pi / 2) * radToDeg,
      (x / earthRadius) * radToDeg,
    );
  }
}
