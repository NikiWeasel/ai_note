import 'package:ai_note/widgets/categories.dart';
import 'package:ai_note/widgets/no_content.dart';
import 'package:ai_note/widgets/notes_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_note/models/sliver_appbar_delegate.dart';
import 'package:ai_note/widgets/input_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_note/provider/note_provider.dart';
import 'package:ai_note/models/note.dart';

class CustomScrollview extends ConsumerWidget {
  const CustomScrollview({super.key});

  //
  // Widget content = notesList.isEmpty
  //     ? NoContent(
  //   onNewNote: () {
  //     noteFunctions.onCreate(ref, context);
  //   },
  //   onAiChat: () {},
  // )
  //     : FutureBuilder(
  //     future: _notesFuture,
  //     builder: (ctx, snapshot) =>
  //     snapshot.connectionState == ConnectionState.waiting
  //         ? const Center(
  //       child: CircularProgressIndicator(),
  //     )
  //         : Expanded(child: NotesList(notes: notesList)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesList = ref.watch(notesProvider);
    final catList = ref.watch(categoriesProvider);
    final catIndexList = ref.watch(categoryIndexProvider);

    List<Note> catNoteList = [];
    List<Note> helpCatNoteList = [];
    if (catIndexList < catList.length &&
        catList[catIndexList].notesList != null) {
      for (var catNote in catList[catIndexList].notesList!) {
        helpCatNoteList =
            notesList.where((note) => note.id == catNote).toList();
        catNoteList = [...helpCatNoteList, ...catNoteList];
      }
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: InputWidget(
                onPressed: (text) {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverAppBarDelegate(
            minHeight: 60.0, // Минимальная высота при закреплении
            maxHeight: 60.0, // Высота виджета в развернутом состоянии
            child: const Categories(),
          ),
        ),
        NotesList(notes: catIndexList == 0 ? notesList : catNoteList)
      ],
    );
  }
}
