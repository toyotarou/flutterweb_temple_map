import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_param/app_param.dart';
import 'temple/temple.dart';
import 'temple_lat_lng/temple_lat_lng.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  AppParamState get appParamState => ref.watch(appParamControllerProvider);

  AppParamController get appParamNotifier => ref.read(appParamControllerProvider.notifier);

//==========================================//

  TempleState get templeState => ref.watch(templeProvider);

  Temple get templeNotifier => ref.read(templeProvider.notifier);

  //==========================================//

  TempleLatLngState get templeLatLngState => ref.watch(templeLatLngProvider as ProviderListenable<TempleLatLngState>);

  TempleLatLng get templeLatLngNotifier => ref.read(templeLatLngProvider.notifier);

//==========================================//
}
