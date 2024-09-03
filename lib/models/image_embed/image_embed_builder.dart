import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ai_note/models/image_embed/image_block_embed.dart';

class ImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => ImageBlockEmbed.imageType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final imageUrl = ImageBlockEmbed(node.value.data).url;

    // Проверяем, является ли путь локальным файлом или URL
    final isLocalFile = !imageUrl.startsWith('http');
    final index = getEmbedNode(controller, node.offset).offset;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: isLocalFile
          ? Image.file(File(imageUrl))
          : Image.network(
              imageUrl,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, color: Colors.red);
              },
            ),
    );
  }
}
