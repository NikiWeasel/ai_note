import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ai_note/models/image_embed/image_block_embed.dart';
import 'package:ai_note/widgets/draggable_image_widget.dart';

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
    // final imageUrl = ImageBlockEmbed(node.value.data, node.value.data).url;
    // bool size = ImageBlockEmbed(node.value.data, node.value.data).size;
    final embed = ImageBlockEmbed(node.value.data);
    final imageUrl = embed.url;
    final isFullSize = embed.isFullSize;
    // final isFullSize = true;

    // Проверяем, является ли путь локальным файлом или URL
    final isLocalFile = !imageUrl.startsWith('http');
    final index = controller.selection.baseOffset;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: isLocalFile
          ? DraggableWidget(
              index: index,
              controller: controller,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    width: isFullSize
                        ? null
                        : MediaQuery.of(context).size.width / 2,
                    File(imageUrl),
                    fit: BoxFit.fill,
                  )),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, color: Colors.red);
                },
              ),
            ),
    );
  }
}
