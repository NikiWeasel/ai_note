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

  final List<Note>? notes;

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

    return widget.notes!.isEmpty
        ? SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Center(
                  child: Text(
                    'Empty Category',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 25),
                  ),
                ),
              ],
            ),
          )
        : SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NoteGritItem(note: widget.notes![index]),
                );
              },
              childCount: widget.notes!.length,
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
