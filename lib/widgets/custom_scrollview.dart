import 'package:ai_note/widgets/notes_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ai_note/models/sliver_appbar_delegate.dart';
import 'package:ai_note/widgets/input_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_note/provider/note_provider.dart';

class CustomScrollview extends ConsumerWidget {
  CustomScrollview({super.key});

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

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
            child: Container(
              color: Colors.orange,
              child: Center(
                child: Text(
                  'Закрепленный контейнер',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        NotesList(notes: notesList)
      ],
    );
  }
}
