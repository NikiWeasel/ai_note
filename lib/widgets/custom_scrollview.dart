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

class CustomScrollview extends ConsumerStatefulWidget {
  const CustomScrollview({super.key});

  @override
  ConsumerState<CustomScrollview> createState() => _CustomScrollviewState();
}

class _CustomScrollviewState extends ConsumerState<CustomScrollview> {
  @override
  Widget build(BuildContext context) {
    final notesList = ref.watch(notesProvider);
    final catList = ref.watch(categoriesProvider);
    final catIndexList = ref.watch(categoryIndexProvider);
    final catContentList = ref.watch(categoryContentProvider);

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
        NotesList(
            notes: catIndexList == 0 || catList.length < catIndexList
                ? notesList
                : catContentList)
      ],
    );
  }
}
