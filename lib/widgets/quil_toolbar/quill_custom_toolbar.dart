import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_font.dart';
import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_formatting.dart';
import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_other.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class QuillCustomToolbar extends StatefulWidget {
  const QuillCustomToolbar({super.key, required this.contentController});

  final quill.QuillController contentController;

  @override
  State<QuillCustomToolbar> createState() {
    return _QuillCustomToolbarState();
  }
}

class _QuillCustomToolbarState extends State<QuillCustomToolbar> {
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
