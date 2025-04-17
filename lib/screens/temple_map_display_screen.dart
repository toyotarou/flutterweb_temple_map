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

  bool isLoading = false;

  final MapController mapController = MapController();

  double currentZoomEightTeen = 18;

  double? currentZoom;

  bool getBoundsZoomValue = false;

  LatLng mapCenter = const LatLng(35.718532, 139.586639);

  ///
  @override
  Widget build(BuildContext context) {
    makeMarker();

    if (appParamState.selectedDate != '' && !appParamState.firstMapChange) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mapController.move(mapCenter, 13);

        appParamNotifier.setFirstMapChange(flag: true);
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(appParamState.selectedDate),
            SizedBox(
              height: context.screenSize.height * 0.7,
              child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: mapCenter,
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
            ),
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
    markerList = <Marker>[];

    final List<TempleModel> dateData = templeState.templeList
        .where((TempleModel element) => element.date.yyyymmdd == appParamState.selectedDate)
        .toList();

    if (dateData.isNotEmpty) {
      final List<String> templeList = <String>[dateData[0].temple];

      if (dateData[0].memo != '') {
        dateData[0].memo.split('、').forEach((String element) => templeList.add(element));
      }

      int j = 0;
      for (final String element in templeList) {
        if (templeLatLngState.templeLatLngMap[element] != null) {
          if (j == 0) {
            mapCenter = LatLng(
              templeLatLngState.templeLatLngMap[element]!.lat.toDouble(),
              templeLatLngState.templeLatLngMap[element]!.lng.toDouble(),
            );
          }

          markerList.add(
            Marker(
              point: LatLng(
                templeLatLngState.templeLatLngMap[element]!.lat.toDouble(),
                templeLatLngState.templeLatLngMap[element]!.lng.toDouble(),
              ),
              width: 40,
              height: 40,
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent.withOpacity(0.8),
                child: Text((j + 1).toString().padLeft(2, '0')),
              ),
            ),
          );

          j++;
        }
      }
    }
  }
}
