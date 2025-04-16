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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Container(
              width: 240,
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Colors.black12)),
              ),
              child: displayTempleDateList(),

              /*


              child: ListView.builder(
                itemCount: appParamState.itemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      appParamNotifier.setSelectedIndex(index: index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: (appParamState.selectedIndex == index) ? Colors.yellowAccent : Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Text(appParamState.itemList[index]),
                            const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),





              */
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
      list.add(
        GestureDetector(
          onTap: () {
            appParamNotifier.setSelectedDate(date: element.date.yyyymmdd);
          },
          child: Container(
            decoration: BoxDecoration(
                color: (appParamState.selectedDate == element.date.yyyymmdd) ? Colors.yellowAccent : Colors.white),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(element.date.yyyymmdd),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
