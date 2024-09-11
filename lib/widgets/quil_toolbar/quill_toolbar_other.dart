import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter/material.dart';

class QuillToolbarOther extends StatefulWidget {
  const QuillToolbarOther({super.key, required this.contentController});

  final quill.QuillController contentController;

  @override
  State<QuillToolbarOther> createState() {
    return _QuillToolbarOtherState();
  }
}

class _QuillToolbarOtherState extends State<QuillToolbarOther> {
  // bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return quill.QuillToolbar.simple(
        controller: widget.contentController,
        configurations: const quill.QuillSimpleToolbarConfigurations(
          showSubscript: false,
          showSuperscript: false,
          showClearFormat: false,
          showClipboardCopy: false,
          showClipboardPaste: false,
          showClipboardCut: false,
          showRedo: false,
          showUndo: false,
          showListNumbers: false,
          showListBullets: false,
          showCodeBlock: false,
          showQuote: false,
          showInlineCode: false,
          showBoldButton: false,
          showItalicButton: false,
          showUnderLineButton: false,
          showDividers: false,
          showColorButton: false,
          showStrikeThrough: false,
          showSearchButton: true,
          showLink: true,
          showFontSize: false,
          showHeaderStyle: false,
          showListCheck: true,
          showAlignmentButtons: false,
          showLeftAlignment: false,
          showIndent: false,
          showBackgroundColorButton: false,
          showFontFamily: false,
          fontSizesValues: {'Small': '8', 'Medium': '24.5', 'Large': '46'},
        ));
  }
}
