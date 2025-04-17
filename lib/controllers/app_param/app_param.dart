import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
    @Default('') String selectedDate,
    @Default(0) double currentZoom,
    @Default(5) int currentPaddingIndex,
    @Default(false) bool firstMapChange,
  }) = _AppParamState;
}

@Riverpod(keepAlive: true)
class AppParamController extends _$AppParamController {
  ///
  @override
  AppParamState build() => const AppParamState();

  ///
  void setSelectedDate({required String date}) => state = state.copyWith(selectedDate: date);

  ///
  void setCurrentZoom({required double zoom}) => state = state.copyWith(currentZoom: zoom);

  ///
  void setFirstMapChange({required bool flag}) => state = state.copyWith(firstMapChange: flag);
}
