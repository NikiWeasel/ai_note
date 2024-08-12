import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_note/models/note.dart';

class SelectedNotesNotifier extends StateNotifier<List<Note>> {
  SelectedNotesNotifier() : super([]);

  bool toggleNoteSelection(Note note) {
    // state = [note, ...state];

    final noteIsSelected = state.contains(note);

    if (noteIsSelected) {
      state = state.where((m) => m.id != note.id).toList();
      return false;
    } else {
      state = [...state, note];
      return true;
    }
  }

  void clearNoteSelection() {
    state = [];
  }
}

final selectedNotesProvider =
    StateNotifierProvider<SelectedNotesNotifier, List<Note>>((ref) {
  return SelectedNotesNotifier();
});
