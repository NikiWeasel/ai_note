import 'dart:io';

import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_font.dart';
import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_formatting.dart';
import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_other.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/image_embed/image_block_embed.dart';

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
  final ImagePicker _picker = ImagePicker();

  Future<void> _insertImage(bool isGallery) async {
    final pickedFile = isGallery
        ? await _picker.pickImage(source: ImageSource.gallery)
        : await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    final File imageFile = File(pickedFile.path);
    final imageUrl = await _uploadImage(imageFile);

    // final image = quill.BlockEmbed.image(imageUrl);
    // final index = widget.contentController.selection.baseOffset;
    // widget.contentController.document.insert(index, image);

    final block = BlockEmbed.custom(ImageBlockEmbed.fromUrl(imageUrl));
    final index = widget.contentController.selection.baseOffset;
    final length = widget.contentController.selection.extentOffset - index;

    widget.contentController.replaceText(index, length, block, null);
  }

  Future<String> _uploadImage(File image) async {
    // Здесь вы можете реализовать загрузку изображения на сервер или другое хранилище
    // Для простоты возвращаем локальный путь
    // Вам нужно заменить этот метод на загрузку на сервер и получение URL
    return image.path;
  }

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
            IconButton(
                onPressed: () {
                  _insertImage(false);
                },
                icon: const Icon(Icons.add_a_photo_outlined)),
            IconButton(
                onPressed: () {
                  _insertImage(true);
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
