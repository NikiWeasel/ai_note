import 'package:ai_note/provider/note_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_note/models/note.dart';
import 'package:ai_note/models/category.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:ai_note/provider/selected_notes_provider.dart';
import 'package:ai_note/provider/toggle_mode_provider.dart';

class ChooseCategory extends ConsumerWidget {
  const ChooseCategory({super.key, required this.selectedNotes});

  final List<Note> selectedNotes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catList = ref.watch(categoriesProvider);
    final catListNotifier = ref.watch(categoriesProvider.notifier);

    void addNoteToCat(Category cat) async {
      for (var note in selectedNotes) {
        final isAvailable = await catListNotifier.linkNoteToCategory(cat, note);
        ref.read(categoriesProvider.notifier).loadCategories();
        if (!isAvailable) {
          showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.info(
                  message: 'Note is already in this category'));
        }
      }
      ref.read(toggleModeProvider.notifier).toggleSelectingMode();
      ref.read(selectedNotesProvider.notifier).clearNoteSelection();
    }

    void deleteAllLinks() async {
      for (var note in selectedNotes) {
        catListNotifier.deleteAllNoteLinks(note);
        ref.read(categoriesProvider.notifier).loadCategories();
        // if (!isAvailable) {
        //   showTopSnackBar(
        //       Overlay.of(context),
        //       const CustomSnackBar.info(
        //           message: 'Note is already in this category'));
        // }
      }
      ref.read(toggleModeProvider.notifier).toggleSelectingMode();
      ref.read(selectedNotesProvider.notifier).clearNoteSelection();
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        padding: const EdgeInsets.only(left: 8, right: 8),
        // margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border:
                Border.all(color: Theme.of(context).colorScheme.onSecondary),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(
              'Move selected notes to:',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSecondary),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var cat in catList)
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.folder_copy_outlined),
                          title: Text(cat.name),
                          onTap: () {
                            addNoteToCat(cat);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.folder_copy_outlined),
                        title: const Text('Delete all links'),
                        onTap: () {
                          deleteAllLinks();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
