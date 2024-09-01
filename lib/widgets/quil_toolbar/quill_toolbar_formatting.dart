import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter/material.dart';

class QuillToolbarFormatting extends StatefulWidget {
  const QuillToolbarFormatting(
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
  State<QuillToolbarFormatting> createState() {
    return _QuillToolbarFormattingState();
  }
}

class _QuillToolbarFormattingState extends State<QuillToolbarFormatting> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              if (!widget.isExpanded) {
                widget.changeToolbarShown('formatting');
                print('format');
              } else {
                widget.changeToolbarShown('all');
                print('all');
              }
              setState(() {
                // print(isExpanded);
                // print(isExpanded);
                // isExpanded = !isExpanded;
                widget.toggle();
              });
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
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showDividers: false,
                  showColorButton: true,
                  showStrikeThrough: true,
                  showSearchButton: false,
                  showLink: false,
                  showFontSize: false,
                  showHeaderStyle: false,
                  showListCheck: false,
                  showAlignmentButtons: false,
                  showLeftAlignment: false,
                  showIndent: false,
                  showBackgroundColorButton: true,
                  showFontFamily: false,
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