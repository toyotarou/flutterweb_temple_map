import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import '../models/temple_model.dart';
import 'temple_map_display_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  ///
  @override
  void initState() {
    super.initState();

    templeNotifier.getAllTemple();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Container(
              width: 240,
              decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.black12))),
              child: displayTempleDateList(),
            ),
            const Expanded(child: TempleMapDisplayScreen()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayTempleDateList() {
    final List<Widget> list = <Widget>[];

    for (final TempleModel element in templeState.templeList) {
      final List<String> templeList = <String>[element.temple];
      if (element.memo != '') {
        element.memo.split('、').forEach(
          (String element2) {
            templeList.add(element2);
          },
        );
      }

      list.add(
        GestureDetector(
          onTap: () {
            appParamNotifier.setSelectedDate(date: element.date.yyyymmdd);
          },
          child: Container(
            decoration: BoxDecoration(
              color: (appParamState.selectedDate == element.date.yyyymmdd)
                  ? Colors.yellowAccent.withOpacity(0.3)
                  : Colors.transparent,
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2))),
            ),
            padding: const EdgeInsets.all(10),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12, color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(element.date.yyyymmdd),
                      const SizedBox.shrink(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: templeList.map(
                      (String e) {
                        return Text(e);
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
