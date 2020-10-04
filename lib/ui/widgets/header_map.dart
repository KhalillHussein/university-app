// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapLocation extends StatelessWidget {
//   final CameraPosition _initialLocation = CameraPosition(
//     target: LatLng(47.219186, 39.712502),
//     zoom: 15.1746,
//   );
//
//   final List<Marker> _markers = [
//     Marker(
//       markerId: MarkerId('1'),
//       position: LatLng(47.219186, 39.712502),
//       infoWindow: InfoWindow(
//         title: 'Северо-Кавказский Филиал МТУСИ',
//       ),
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       markers: _markers.toSet(),
//       initialCameraPosition: _initialLocation,
//       indoorViewEnabled: true,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../../util/url.dart';

/// Used as a sliver header, in the [background] parameter.
/// It allows to navigate through a map area, including multiple markers.
class MapHeader extends StatelessWidget {
  static const double _markerSize = 40.0;
  final LatLng point;

  const MapHeader(this.point);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: point,
        zoom: 17,
        minZoom: 8,
        maxZoom: 20,
      ),
      layers: <LayerOptions>[
        TileLayerOptions(
          urlTemplate: Theme.of(context).brightness == Brightness.light
              ? Url.lightMap
              : Url.darkMap,
          subdomains: ['a', 'b', 'c', 'd'],
          backgroundColor: Theme.of(context).primaryColor,
        ),
        MarkerLayerOptions(markers: <Marker>[
          Marker(
            width: _markerSize,
            height: _markerSize,
            point: point,
            builder: (context) => Icon(
              Icons.location_on,
              color: Color(0xFF4CAF50),
              size: _markerSize,
            ),
          )
        ])
      ],
    );
  }
}
