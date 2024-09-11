import 'dart:io';

import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_font.dart';
import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_formatting.dart';
import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_other.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_note/provider/quill_embed_provider.dart';

class QuillCustomToolbar extends ConsumerStatefulWidget {
  const QuillCustomToolbar({super.key, required this.contentController});

  final quill.QuillController contentController;

  @override
  ConsumerState<QuillCustomToolbar> createState() {
    return _QuillCustomToolbarState();
  }
}

class _QuillCustomToolbarState extends ConsumerState<QuillCustomToolbar> {
  String toolbarShown = 'all';
  bool isExpandedFont = false;
  bool isExpandedFormatting = false;

  void changeToolbarShown(String newValue) {
    setState(() {
      toolbarShown = newValue;
    });
  }

  void toggleIsExpandedFont() {
    setState(() {
      isExpandedFont = !isExpandedFont;
    });
  }

  void toggleIsExpandedFormatting() {
    setState(() {
      isExpandedFormatting = !isExpandedFormatting;
    });
  }

  @override
  Widget build(BuildContext context) {
    final embedFunProvider = ref.watch(quillEmbedProvider);

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QuillToolbarFont(
          contentController: widget.contentController,
          changeToolbarShown: changeToolbarShown,
          isExpanded: isExpandedFont,
          toggle: toggleIsExpandedFont,
        ),
        QuillToolbarFormatting(
          contentController: widget.contentController,
          changeToolbarShown: changeToolbarShown,
          isExpanded: isExpandedFormatting,
          toggle: toggleIsExpandedFormatting,
        ),
        QuillToolbarOther(contentController: widget.contentController),
      ],
    );

    switch (toolbarShown) {
      case 'all':
        content = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuillToolbarFont(
              contentController: widget.contentController,
              changeToolbarShown: changeToolbarShown,
              isExpanded: isExpandedFont,
              toggle: toggleIsExpandedFont,
            ),
            QuillToolbarFormatting(
              contentController: widget.contentController,
              changeToolbarShown: changeToolbarShown,
              isExpanded: isExpandedFormatting,
              toggle: toggleIsExpandedFormatting,
            ),
            QuillToolbarOther(contentController: widget.contentController),
            IconButton(
                onPressed: () {
                  embedFunProvider.onInsert(widget.contentController, false);
                },
                icon: const Icon(Icons.add_a_photo_outlined)),
            IconButton(
                onPressed: () {
                  embedFunProvider.onInsert(widget.contentController, true);
                },
                icon: Transform.flip(
                    flipX: true,
                    child: const Icon(Icons.add_photo_alternate_outlined)))
          ],
        );
      case 'font':
        content = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuillToolbarFont(
              contentController: widget.contentController,
              changeToolbarShown: changeToolbarShown,
              isExpanded: isExpandedFont,
              toggle: toggleIsExpandedFont,
            ),
          ],
        );
      case 'formatting':
        content = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuillToolbarFormatting(
              contentController: widget.contentController,
              changeToolbarShown: changeToolbarShown,
              isExpanded: isExpandedFormatting,
              toggle: toggleIsExpandedFormatting,
            ),
          ],
        );
    }

    return content;
  }
}
