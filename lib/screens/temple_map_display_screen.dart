import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/controllers_mixin.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text(appParamState.selectedDate),
          ],
        ),
      ),
    );
  }
}
