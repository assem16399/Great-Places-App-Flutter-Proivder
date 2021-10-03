import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialPlaceLocation;
  final bool isSelecting;

  const MapScreen({
    this.initialPlaceLocation = const PlaceLocation(
        latitude: 37.42796133580664,
        longitude: -122.085749655962,
        address: 'Google Plex'),
    this.isSelecting = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  void _selectLocation(LatLng? position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: _pickedLocation != null
                    ? () {
                        Navigator.of(context).pop(_pickedLocation);
                      }
                    : null,
                icon: const Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialPlaceLocation.latitude,
              widget.initialPlaceLocation.longitude),
          zoom: 14.4746,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation != null || !widget.isSelecting)
            ? {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(widget.initialPlaceLocation.latitude,
                          widget.initialPlaceLocation.longitude),
                ),
              }
            : {},
      ),
    );
  }
}
