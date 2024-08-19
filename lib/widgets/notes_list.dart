import 'package:flutter/cupertino.dart';
import 'package:ai_note/models/note.dart';
import 'package:ai_note/widgets/note_grit_item.dart';
import 'package:flutter/material.dart';
import 'package:ai_note/screens/note_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_note/provider/toggle_mode_provider.dart';
import 'package:ai_note/provider/note_provider.dart';

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

    final notesList = ref.watch(notesProvider);

    // return GridView(
    //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    //     // crossAxisCount: 2,
    //     childAspectRatio: 2.5 / 2,
    //     // crossAxisSpacing: 20,
    //     // mainAxisSpacing: 20,
    //     maxCrossAxisExtent: 250,
    //   ),
    //   children: [
    //     for (final note in widget.notes)
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: NoteGritItem(
    //           note: note,
    //         ),
    //       )
    //   ],
    // );

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: NoteGritItem(note: widget.notes[index]),
          );
        },
        childCount: notesList.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //TODO поменять (будет плохо выглядить на большом экране)
        crossAxisCount: 2,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        childAspectRatio: 1.0,
      ),
    );
  }
}
