import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import '../models/temple_model.dart';

class TempleMapDisplayScreen extends ConsumerStatefulWidget {
  const TempleMapDisplayScreen({super.key});

  @override
  ConsumerState<TempleMapDisplayScreen> createState() => _TempleMapDisplayScreenState();
}

class _TempleMapDisplayScreenState extends ConsumerState<TempleMapDisplayScreen>
    with ControllersMixin<TempleMapDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(appParamState.selectedDate),
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
        list.add(Text(element));
      }
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
