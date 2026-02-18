import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_selection_manager.g.dart';

@riverpod
class SearchSelectionManager extends _$SearchSelectionManager {
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
