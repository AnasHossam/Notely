import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_selection_manager.g.dart';

@riverpod
class HomeSelectionManager extends _$HomeSelectionManager {
  @override
  Set<String> build() {
    return {};
  }

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state}..add(id);
    }
  }

  void select(String id) {
    if (!state.contains(id)) {
      state = {...state}..add(id);
    }
  }

  void clear() {
    state = {};
  }

  bool isSelected(String id) {
    return state.contains(id);
  }

  bool get isSelectionMode => state.isNotEmpty;
}
