import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_note/models/image_embed/image_block_embed.dart';
import 'package:ai_note/provider/quill_embed_provider.dart';

class DraggableWidget extends ConsumerStatefulWidget {
  final Widget child;
  final int index;
  final QuillController controller;

  const DraggableWidget({
    required this.child,
    required this.index,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends ConsumerState<DraggableWidget> {
  // BlockEmbed? getBlockEmbedAt(Document document, int index) {
  //   final delta = document.toDelta();
  //   int currentIndex = 0;
  //
  //   for (final op in delta.toList()) {
  //     final opLength = op.length ?? 0;
  //
  //     if (op.isEmbed && currentIndex == index) {
  //       return BlockEmbed(op.data);
  //     }
  //
  //     currentIndex += opLength;
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    final embedFunProvider = ref.watch(quillEmbedProvider);

    return Stack(children: [
      GestureDetector(
        onLongPress: () {
          // Начинаем перетаскивание при длительном нажатии
          print('dragging' + widget.index.toString());
          final jj = widget.controller.document.toDelta().toString();
          print(jj);
          _startDragging(context);
        },
        onTap: () {
          // Показать контекстное меню при коротком нажатии
          // final BlockEmbed blockEmbed = widget.controller.document.(widget.index);
          _showContextMenu(
              context, embedFunProvider, widget.controller, widget.index);
        },
        child: Draggable<int>(
          data: widget.index,
          feedback: Material(
            child: Opacity(
              opacity: 0.75,
              child: SizedBox(
                  height: 150,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: widget.child)),
            ),
          ), // Визуальный эффект перетаскивания
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: widget.child,
          ),
          child: widget.child,
        ),
      ),
      DragTarget<String>(
        onAccept: (imageUrl) {
          // Вставляем изображение на новое место
          final index = widget.controller.selection.baseOffset;
          final block = BlockEmbed.custom(ImageBlockEmbed.fromUrl(imageUrl));
          widget.controller.replaceText(index, 0, block, null);
        },
        builder: (context, candidateData, rejectedData) {
          return const SizedBox.shrink(); // Placeholder для места вставки
        },
      ),
    ]);
  }

  void _startDragging(BuildContext context) {
    // Функциональность для начала перетаскивания реализована через Draggable
  }

  void _showContextMenu(
      BuildContext context,
      QuillEmbedProvider embedFunProvider,
      QuillController contentController,
      int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.fullscreen_exit),
            title: const Text('Resize'),
            onTap: () {
              Navigator.pop(context);
              embedFunProvider.onResize(contentController, index);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              embedFunProvider.onDelete(contentController, index);
            },
          ),
          // Другие действия
        ],
      ),
    );
  }
}
