import 'package:ai_note/provider/selected_notes_provider.dart';
import 'package:ai_note/provider/toggle_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:ai_note/models/note.dart';
import 'package:ai_note/screens/note_screen.dart';
import 'package:ai_note/provider/note_provider.dart';
import 'package:path/path.dart';

void _createNote(WidgetRef ref, BuildContext context) async {
  Note newNote = await Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) =>
          NoteScreen(note: Note(title: 'New Note', content: ''))));
  if (newNote.title == 'New Note' && newNote.content == '') {
    return;
  }
  ref.read(notesProvider.notifier).addNote(newNote.title, newNote.content);
}

void _editNote(WidgetRef ref, BuildContext context, Note oldNote) async {
  Note editedNote = await Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => NoteScreen(
          note: Note(title: oldNote.title, content: oldNote.content))));
  if (editedNote.title == oldNote.title &&
      editedNote.content == oldNote.content) {
    return;
  }
  ref
      .read(notesProvider.notifier)
      .editNote(oldNote, editedNote.title, editedNote.content);
}

void _deleteNote(
    WidgetRef ref, BuildContext context, List<Note> notesToDelete) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: Text(
            'Delete ${notesToDelete.length} notes?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                for (var note in notesToDelete) {
                  ref.read(notesProvider.notifier).deleteNote(note);
                }
                Navigator.of(context).pop();
                ref.read(toggleModeProvider.notifier).toggleSelectingMode();
                ref.read(selectedNotesProvider.notifier).clearNoteSelection();
              },
            ),
          ],
        );
      });
}

class NoteActionsProvider {
  final void Function(WidgetRef, BuildContext) onCreate;
  final void Function(WidgetRef ref, BuildContext context, Note oldNote) onEdit;
  final void Function(
      WidgetRef ref, BuildContext context, List<Note> notesToDelete) onDelete;

  NoteActionsProvider({
    required this.onCreate,
    required this.onEdit,
    required this.onDelete,
  });
}

// Создаем Provider для предоставления инстанса ActionsProvider
final noteActionsProvider = Provider<NoteActionsProvider>((ref) {
  return NoteActionsProvider(
    onCreate: _createNote,
    onEdit: _editNote,
    onDelete: _deleteNote,
  );
});
