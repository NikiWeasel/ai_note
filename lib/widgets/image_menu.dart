import 'dart:ui';
import 'package:ai_note/models/image_embed/image_block_embed.dart';
import 'package:ai_note/provider/quill_embed_provider.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageMenu extends StatefulWidget {
  const ImageMenu(
      {super.key,
      required this.child,
      required this.controller,
      required this.embed});

  final Widget child;
  final ImageBlockEmbed embed;
  final QuillController controller;

  @override
  State<ImageMenu> createState() {
    return ImageMenuState();
  }
}

class ImageMenuState extends State<ImageMenu> {
  bool isMenuOpened = false;
  int index = -1;

  void changeMenuStatus() {
    setState(() {
      isMenuOpened = !isMenuOpened;
    });
  }

  int findImageLineIndex(QuillController controller, String imageUrl) {
    final delta = controller.document.toDelta();
    int lineIndex = 0;

    for (final op in delta.toList()) {
      if (op.isInsert) {
        final data = op.data;
        if (data is Map && data.containsKey('custom')) {
          final custom = data['custom'];
          // print(custom);
          // print(imageUrl);

          if (custom.toString().contains(imageUrl)) {
            return lineIndex;
          }
        }
        if (data is String) {
          lineIndex += data.length;
        }
      }
    }
    print(delta);
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        index = findImageLineIndex(widget.controller, widget.embed.data);
        // print(widget.embed.isFullSize);
        changeMenuStatus();
        showModalBottomSheet(
            context: context,
            builder: (bb) =>
                EditingImageMenu(widget.controller, index, widget.embed));
      },
      child: widget.child,
    );
  }
}

class EditingImageMenu extends ConsumerStatefulWidget {
  const EditingImageMenu(this.contentController, this.index, this.embed,
      {super.key});

  final QuillController contentController;
  final int index;
  final ImageBlockEmbed embed;

  @override
  ConsumerState<EditingImageMenu> createState() => _EditingImageMenuState();
}

class _EditingImageMenuState extends ConsumerState<EditingImageMenu> {
  // final isFullSize = embed.isFullSize;

  @override
  Widget build(BuildContext context) {
    final funProv = ref.watch(quillEmbedProvider);
    // print(widget.embed.isFullSize);
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,

        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.fullscreen_exit),
            title: Text('Data'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.fullscreen_exit),
            title: Text('Data'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.fullscreen_exit),
            title: Text('Data'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.fullscreen_exit),
            title: Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              funProv.onDelete(widget.contentController, widget.index);
            },
          ),
        ],
      ),
    );
  }
}
