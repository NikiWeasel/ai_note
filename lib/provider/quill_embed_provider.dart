import 'dart:io';
import 'package:ai_note/provider/selected_notes_provider.dart';
import 'package:ai_note/provider/toggle_mode_provider.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:ai_note/models/note.dart';
import 'package:ai_note/screens/note_screen.dart';
import 'package:ai_note/provider/note_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:ai_note/models/image_embed/image_block_embed.dart';

Future<void> _insertImage(
    QuillController contentController, bool isGallery) async {
  final ImagePicker picker = ImagePicker();

  final pickedFile = isGallery
      ? await picker.pickImage(source: ImageSource.gallery)
      : await picker.pickImage(source: ImageSource.camera);
  if (pickedFile == null) return;

  final File imageFile = File(pickedFile.path);
  final imageUrl = imageFile.path;

  // final image = quill.BlockEmbed.image(imageUrl);
  // final index = widget.contentController.selection.baseOffset;
  // widget.contentController.document.insert(index, image);

  final block = BlockEmbed.custom(ImageBlockEmbed.fromUrl(imageUrl));
  final index = contentController.selection.baseOffset;
  final length = contentController.selection.extentOffset - index;

  contentController.replaceText(index, length, block, null);
}

void _resizeWidget(QuillController contentController, int index) {
  contentController.document.delete(index, 1);
}

void _deleteWidget(QuillController contentController, int index) {
  contentController.document.delete(index, 1);
}

class QuillEmbedProvider {
  final void Function(QuillController contentController, bool isGallery)
      onInsert;
  final void Function(QuillController contentController, int index) onResize;
  final void Function(QuillController contentController, int index) onDelete;

  QuillEmbedProvider({
    required this.onInsert,
    required this.onResize,
    required this.onDelete,
  });
}

// Создаем Provider для предоставления инстанса ActionsProvider
final quillEmbedProvider = Provider<QuillEmbedProvider>((ref) {
  return QuillEmbedProvider(
    onInsert: _insertImage,
    onResize: _resizeWidget,
    onDelete: _deleteWidget,
  );
});
