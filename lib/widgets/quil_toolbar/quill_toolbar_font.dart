import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter/material.dart';

class QuillToolbarFont extends StatefulWidget {
  const QuillToolbarFont(
      {super.key,
      required this.contentController,
      required this.changeToolbarShown,
      required this.isExpanded,
      required this.toggle});

  final quill.QuillController contentController;
  final void Function(String newValue) changeToolbarShown;
  final bool isExpanded;
  final void Function() toggle;

  @override
  State<QuillToolbarFont> createState() {
    return _QuillToolbarFontState();
  }
}

class _QuillToolbarFontState extends State<QuillToolbarFont> {
  // bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              if (!widget.isExpanded) {
                widget.changeToolbarShown('font');
              } else {
                widget.changeToolbarShown('all');
              }
              widget.toggle();
            },
            icon: widget.isExpanded
                ? const Icon(Icons.arrow_back_ios_new_outlined)
                : const Icon(Icons.arrow_forward_ios_outlined)),
        widget.isExpanded
            ? quill.QuillToolbar.simple(
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
                  showSearchButton: false,
                  showLink: false,
                  showFontSize: true,
                  showHeaderStyle: true,
                  showListCheck: false,
                  showAlignmentButtons: false,
                  showLeftAlignment: false,
                  showIndent: false,
                  showBackgroundColorButton: false,
                  fontSizesValues: {
                    'Small': '8',
                    'Medium': '24.5',
                    'Large': '46'
                  },
                ))
            : const SizedBox.shrink(),
        // Icon(Icons.straight)
      ],
    );
  }
}
