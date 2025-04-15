import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/controllers_mixin.dart';
import 'temple_map_display_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
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
            ),
            const Expanded(child: TempleMapDisplayScreen()),
          ],
        ),
      ),
    );
  }
}
