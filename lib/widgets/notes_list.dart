import 'package:flutter/cupertino.dart';
import 'package:ai_note/models/note.dart';
import 'package:ai_note/widgets/note_grit_item.dart';
import 'package:flutter/material.dart';
import 'package:ai_note/screens/note_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_note/provider/toggle_mode_provider.dart';
import 'main_drawer.dart';

class NotesList extends ConsumerStatefulWidget {
  const NotesList({super.key, required this.notes});

  final List<Note> notes;

  @override
  ConsumerState<NotesList> createState() {
    return _NoteListState();
  }
}

class _NoteListState extends ConsumerState<NotesList> {
  @override
  Widget build(BuildContext context) {
    final isSelectingMode =
        ref.watch(toggleModeProvider); //TODO сделать анимацию тряски

    return GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        // crossAxisCount: 2,
        childAspectRatio: 2.5 / 2,
        // crossAxisSpacing: 20,
        // mainAxisSpacing: 20,
        maxCrossAxisExtent: 250,
      ),
      children: [
        for (final note in widget.notes)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NoteGritItem(
              note: note,
            ),
          )
      ],
    );
  }
}
