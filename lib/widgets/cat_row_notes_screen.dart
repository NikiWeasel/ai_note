import 'package:ai_note/provider/note_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_note/models/category.dart';
import 'package:ai_note/models/note.dart';
import 'cat_tags_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatRowNotesScreen extends ConsumerStatefulWidget {
  const CatRowNotesScreen(
      {super.key, required this.catList, required this.note});

  final List<Category> catList;
  final Note note;

  @override
  ConsumerState<CatRowNotesScreen> createState() => _CatRowNotesScreenState();
}

class _CatRowNotesScreenState extends ConsumerState<CatRowNotesScreen> {
  @override
  Widget build(BuildContext context) {
    var categoriesNotifier = ref.watch(categoriesProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 8,
        ),
        for (var cat in widget.catList)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CatTagsWidget(
              category: cat,
              deleteCat: (cat, note) {
                setState(() {
                  categoriesNotifier.deleteCatNoteLinks(cat, note);
                });
              },
              note: widget.note,
            ),
          ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }
}
