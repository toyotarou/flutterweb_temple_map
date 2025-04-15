import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_param/app_param.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  AppParamState get appParamState => ref.watch(appParamControllerProvider);

  AppParamController get appParamNotifier => ref.read(appParamControllerProvider.notifier);

//==========================================//
}
