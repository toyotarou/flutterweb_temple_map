import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
    @Default(<String>[]) List<String> itemList,
    @Default(-1) int selectedIndex,
  }) = _AppParamState;
}

@Riverpod(keepAlive: true)
class AppParamController extends _$AppParamController {
  ///
  @override
  AppParamState build() {
    // ignore: always_specify_types
    return AppParamState(itemList: List.generate(100, (int index) => 'item-$index'));
  }

  ///
  void setSelectedIndex({required int index}) => state = state.copyWith(selectedIndex: index);
}
