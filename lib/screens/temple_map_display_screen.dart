import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import '../models/common/temple_data.dart';
import '../models/temple_model.dart';
import '../utility/tile_provider.dart';

class TempleMapDisplayScreen extends ConsumerStatefulWidget {
  const TempleMapDisplayScreen({super.key});

  @override
  ConsumerState<TempleMapDisplayScreen> createState() => _TempleMapDisplayScreenState();
}

class _TempleMapDisplayScreenState extends ConsumerState<TempleMapDisplayScreen>
    with ControllersMixin<TempleMapDisplayScreen> {
  List<TempleData> templeDataList = <TempleData>[];

  List<Marker> markerList = <Marker>[];

  List<double> latList = <double>[];
  List<double> lngList = <double>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  bool isLoading = false;

  final MapController mapController = MapController();

  double currentZoomEightTeen = 18;

  double? currentZoom;

  bool getBoundsZoomValue = false;

  ///
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => isLoading = true);

      // ignore: always_specify_types
      Future.delayed(const Duration(seconds: 2), () {
        setDefaultBoundsMap();

        setState(() => isLoading = false);
      });
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeMarker();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(appParamState.selectedDate),
            if (appParamState.selectedDate != '') ...<Widget>[
              SizedBox(
                height: context.screenSize.height * 0.5,
                child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: const LatLng(35.718532, 139.586639),
                      initialZoom: currentZoomEightTeen,
                      onPositionChanged: (MapCamera position, bool isMoving) {
                        if (isMoving) {
                          appParamNotifier.setCurrentZoom(zoom: position.zoom);
                        }
                      },
                    ),
                    children: <Widget>[
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        tileProvider: CachedTileProvider(),
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(markers: markerList),
                    ]),
              )
            ],
            const SizedBox(height: 20),
            displayDateTemple(),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayDateTemple() {
    final List<Widget> list = <Widget>[];

    final List<TempleModel> dateData = templeState.templeList
        .where((TempleModel element) => element.date.yyyymmdd == appParamState.selectedDate)
        .toList();

    if (dateData.isNotEmpty) {
      final List<String> templeList = <String>[dateData[0].temple];

      if (dateData[0].memo != '') {
        dateData[0].memo.split('、').forEach((String element) {
          templeList.add(element);
        });
      }

      for (final String element in templeList) {
        list.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(element),
            if (templeLatLngState.templeLatLngMap[element] != null) ...<Widget>[
              Text(
                '${templeLatLngState.templeLatLngMap[element]!.lat} / ${templeLatLngState.templeLatLngMap[element]!.lng}',
              ),
            ],
            if (templeLatLngState.templeLatLngMap[element] == null) ...<Widget>[const SizedBox.shrink()],
          ],
        ));
      }
    }

    return SingleChildScrollView(child: Column(children: list));
  }

  ///
  void makeMarker() {
    latList = <double>[];
    lngList = <double>[];

    markerList = <Marker>[];

    final List<TempleModel> dateData = templeState.templeList
        .where((TempleModel element) => element.date.yyyymmdd == appParamState.selectedDate)
        .toList();

    if (dateData.isNotEmpty) {
      final List<String> templeList = <String>[dateData[0].temple];

      if (dateData[0].memo != '') {
        dateData[0].memo.split('、').forEach((String element) {
          templeList.add(element);
        });
      }

      for (final String element in templeList) {
        if (templeLatLngState.templeLatLngMap[element] != null) {
          markerList.add(
            Marker(
              point: LatLng(
                templeLatLngState.templeLatLngMap[element]!.lat.toDouble(),
                templeLatLngState.templeLatLngMap[element]!.lng.toDouble(),
              ),
              width: 40,
              height: 40,
              child: const CircleAvatar(),
            ),
          );

          latList.add(templeLatLngState.templeLatLngMap[element]!.lat.toDouble());

          lngList.add(templeLatLngState.templeLatLngMap[element]!.lng.toDouble());
        }
      }

      if (latList.isNotEmpty && lngList.isNotEmpty) {
        minLat = latList.reduce(min);
        maxLat = latList.reduce(max);
        minLng = lngList.reduce(min);
        maxLng = lngList.reduce(max);
      }
    }
  }

  ///
  void setDefaultBoundsMap() {
//    if (templeDataList.length > 1) {
    // final List<double> stationLatList = <double>[];
    // final List<double> stationLngList = <double>[];
    //
    // if (tokyoTrainState.selectTrainList.isNotEmpty) {
    //   final TokyoTrainModel? map = widget.tokyoTrainIdMap[tokyoTrainState.selectTrainList[0]];
    //
    //   map?.station.forEach((TokyoStationModel element) {
    //     stationLatList.add(element.lat.toDouble());
    //     stationLngList.add(element.lng.toDouble());
    //   });
    //
    //   minLat = stationLatList.reduce(min);
    //   maxLat = stationLatList.reduce(max);
    //   minLng = stationLngList.reduce(min);
    //   maxLng = stationLngList.reduce(max);
    // }

    final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)]);

    final CameraFit cameraFit =
        CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(appParamState.currentPaddingIndex * 10));

    mapController.fitCamera(cameraFit);

    /// これは残しておく
    // final LatLng newCenter = mapController.camera.center;

    final double newZoom = mapController.camera.zoom;

    setState(() => currentZoom = newZoom);

    appParamNotifier.setCurrentZoom(zoom: newZoom);

    getBoundsZoomValue = true;
  }
//  }
}
