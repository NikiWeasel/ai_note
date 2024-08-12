import 'package:ai_note/provider/selected_notes_provider.dart';
import 'package:ai_note/provider/toggle_mode_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ai_note/models/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_note/provider/function_provider.dart';

class NoteGritItem extends ConsumerStatefulWidget {
  const NoteGritItem({
    super.key,
    required this.note,
    // required this.onChangeMode,
    // required this.isSelectingMode,
  });

  final Note note;

  // final void Function() onChangeMode;
  // final bool isSelectingMode;

  @override
  ConsumerState<NoteGritItem> createState() => _NoteGritItemState();
}

class _NoteGritItemState extends ConsumerState<NoteGritItem> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final noteFunctions = ref.watch(noteActionsProvider);
    final isSelectingMode = ref.watch(toggleModeProvider);
    final selectedNotes = ref.watch(selectedNotesProvider.notifier);

    void checkItem() {
      setState(() {
        _isChecked = !_isChecked;
      });
      selectedNotes.toggleNoteSelection(widget.note);
    }

    Widget checkedWidget = SizedBox(
      width: 15,
      height: 15,
      child: Checkbox(
          value: _isChecked,
          onChanged: (bool? value) {
            checkItem();
          }),
    );

    return InkWell(
      onTap: () {
        if (isSelectingMode) {
          checkItem();
        } else {
          noteFunctions.onEdit(ref, context, widget.note);
        }
      },
      onLongPress: () {
        ref.read(selectedNotesProvider.notifier).clearNoteSelection();
        ref.read(toggleModeProvider.notifier).toggleSelectingMode();
        if (isSelectingMode) {
          checkItem();
        }
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.9),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.note.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.note.content,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                maxLines: 2,
                overflow: TextOverflow.fade,
              ),
            ),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isSelectingMode) checkedWidget,
                Spacer(),
                Text(
                  widget.note.dateTime.toString(),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  maxLines: 1,
                ),
              ],
            ),
            // checkedWidget
          ],
        ),
      ),
    );
  }
}
