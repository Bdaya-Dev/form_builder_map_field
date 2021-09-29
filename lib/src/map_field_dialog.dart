import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationFieldDialog extends StatefulWidget {
  final CameraPosition? initialCameraPosition;
  final IconData? markerIcon;
  final double markerIconSize;
  final Color? markerIconColor;
  final MapType mapType;
  final bool myLocationButtonEnabled;
  final bool myLocationEnabled;
  final bool zoomGesturesEnabled;
  final Set<Marker> markers;
  final void Function(LatLng)? onTap;
  final EdgeInsets padding;
  final bool buildingsEnabled;
  final CameraTargetBounds cameraTargetBounds;
  final Set<Circle> circles;
  final bool compassEnabled;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final bool indoorViewEnabled;
  final bool mapToolbarEnabled;
  final MinMaxZoomPreference minMaxZoomPreference;
  final VoidCallback? onCameraIdle;
  final VoidCallback? onCameraMoveStarted;
  final void Function(LatLng)? onLongPress;
  final Set<Polygon> polygons;
  final Set<Polyline> polylines;
  final bool rotateGesturesEnabled;
  final bool scrollGesturesEnabled;
  final bool tiltGesturesEnabled;
  final bool trafficEnabled;
  final bool zoomControlsEnabled;
  final bool liteModeEnabled;
  final CameraPositionCallback? onCameraMove;
  final MapCreatedCallback? onMapCreated;

  const LocationFieldDialog({
    Key? key,
    this.initialCameraPosition,
    this.mapType = MapType.normal,
    this.markerIcon,
    required this.markerIconSize,
    this.markerIconColor,
    this.myLocationButtonEnabled = true,
    this.myLocationEnabled = false,
    this.zoomGesturesEnabled = true,
    this.markers = const {},
    this.onTap,
    this.padding = EdgeInsets.zero,
    this.buildingsEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.circles = const {},
    this.compassEnabled = true,
    this.gestureRecognizers = const {},
    this.indoorViewEnabled = false,
    this.mapToolbarEnabled = true,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.onCameraIdle,
    this.onCameraMoveStarted,
    this.onLongPress,
    this.polygons = const {},
    this.polylines = const {},
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.trafficEnabled = false,
    this.zoomControlsEnabled = true,
    this.liteModeEnabled = false,
    this.onCameraMove,
    this.onMapCreated,
  }) : super(key: key);

  @override
  _LocationFieldDialogState createState() => _LocationFieldDialogState();
}

class _LocationFieldDialogState extends State<LocationFieldDialog> {
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  late CameraPosition _value;
  late CameraPosition _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = widget.initialCameraPosition ??
        CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        );
    _value = _initialCameraPosition;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () => Navigator.pop(context, _value),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.biggest.width;
          final maxHeight = constraints.biggest.height;

          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                height: maxHeight,
                width: maxWidth,
                child: GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controllerCompleter.isCompleted) {
                      _controllerCompleter.complete(controller);
                    }
                    widget.onMapCreated?.call(controller);
                  },
                  onCameraMove: (CameraPosition newPosition) {
                    _value = newPosition;
                    widget.onCameraMove?.call(newPosition);
                  },
                  mapType: widget.mapType,
                  myLocationButtonEnabled: widget.myLocationButtonEnabled,
                  myLocationEnabled: widget.myLocationEnabled,
                  zoomGesturesEnabled: widget.zoomGesturesEnabled,
                  markers: widget.markers,
                  onTap: widget.onTap,
                  padding: widget.padding,
                  buildingsEnabled: widget.buildingsEnabled,
                  cameraTargetBounds: widget.cameraTargetBounds,
                  circles: widget.circles,
                  compassEnabled: widget.compassEnabled,
                  gestureRecognizers: widget.gestureRecognizers,
                  indoorViewEnabled: widget.indoorViewEnabled,
                  mapToolbarEnabled: widget.mapToolbarEnabled,
                  minMaxZoomPreference: widget.minMaxZoomPreference,
                  onCameraIdle: widget.onCameraIdle,
                  onCameraMoveStarted: widget.onCameraMoveStarted,
                  onLongPress: widget.onLongPress,
                  polygons: widget.polygons,
                  polylines: widget.polylines,
                  rotateGesturesEnabled: widget.rotateGesturesEnabled,
                  scrollGesturesEnabled: widget.scrollGesturesEnabled,
                  tiltGesturesEnabled: widget.tiltGesturesEnabled,
                  trafficEnabled: widget.trafficEnabled,
                  liteModeEnabled: widget.liteModeEnabled,
                  zoomControlsEnabled: widget.zoomControlsEnabled,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FloatingActionButton(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      child: Icon(
                        Icons.close,
                        color: theme.textTheme.bodyText1?.color,
                      ),
                      onPressed: () => Navigator.pop(context),
                      mini: true,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: maxHeight / 2,
                right: (maxWidth - widget.markerIconSize) / 2,
                child: Container(
                  // key: Key(),
                  child: Icon(
                    widget.markerIcon,
                    size: widget.markerIconSize,
                    color: widget.markerIconColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
