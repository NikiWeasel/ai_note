import 'dart:convert';
import 'package:ai_note/widgets/cat_row_notes_screen.dart';
import 'package:ai_note/widgets/cat_tags_widget.dart';
import 'package:ai_note/widgets/quil_toolbar/quill_custom_toolbar.dart';
import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_font.dart';
import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_other.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_toolbar/markdown_toolbar.dart';
import 'package:ai_note/models/note.dart';
import 'package:ai_note/provider/note_provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:ai_note/models/category.dart';
import 'package:ai_note/widgets/overlay_boundary.dart';

import 'package:ai_note/widgets/quil_toolbar/quill_toolbar_formatting.dart';

class NoteScreen extends ConsumerStatefulWidget {
  const NoteScreen({super.key, required this.note});

  final Note note;

  // void Function() onSelected;

  @override
  ConsumerState<NoteScreen> createState() {
    return _NoteScreenState();
  }
}

class _NoteScreenState extends ConsumerState<NoteScreen> {
  final quill.QuillController _contentController =
      quill.QuillController.basic();
  final TextEditingController _titleController = TextEditingController();
  List<Category> catList = [];

  final _focusNode = FocusNode();
  bool isEditing = true;

  _changeMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void setCatList(List<Category> allCatList) {
    catList = [];

    for (var category in allCatList) {
      var notesList = category.notesList ?? [];

      if (notesList.contains(widget.note.id)) {
        catList.add(category);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // _contentController.text = widget.note.content;
    _titleController.text = widget.note.title;

    //////////////////
    if (widget.note.content.isNotEmpty) {
      final json = jsonDecode(widget.note.content);

      _contentController.document = Document.fromJson(json);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categoriesList = ref.watch(categoriesProvider);
    final categoriesNotifier = ref.watch(categoriesProvider.notifier);

    setCatList(categoriesList);
    categoriesNotifier.loadCategories();

    double minHeight = MediaQuery.of(context).size.height -
        2 * MediaQuery.of(context).viewInsets.bottom; //TODO исправить хз как
    // print(MediaQuery.of(context).size.height -
    //     MediaQuery.of(context).viewInsets.bottom);
    bool hasUndo = _contentController.hasUndo;
    bool hasRedo = _contentController.hasRedo;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Title',
          ),
        ),
        actions: [
          IconButton(
            icon: hasUndo
                ? const Icon(Icons.undo)
                : Icon(
                    Icons.undo,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2),
                  ),
            onPressed: hasUndo
                ? () {
                    _contentController.undo();
                  }
                : null,
          ),
          IconButton(
            icon: hasRedo
                ? const Icon(Icons.redo)
                : Icon(
                    Icons.redo,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2),
                  ),
            onPressed: _contentController.hasRedo
                ? () {
                    _contentController.redo();
                  }
                : null,
          ),
          IconButton(
              onPressed: () {
                _changeMode();
                // print(_widgetHeight);
              },
              icon: isEditing ? const Icon(Icons.done) : const Icon(Icons.edit))
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) return;
          Navigator.of(context).pop(Note(
              title: _titleController.text,
              content: jsonEncode(_contentController.document
                  .toDelta()
                  .toJson()))); //TODO plaintext -> json idk
        },
        child: OverlayBoundary(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: CatRowNotesScreen(
                              catList: catList,
                              note: widget.note,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Last edit: ${widget.note.dateTime}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: minHeight,
                                ),
                                child: quill.QuillEditor.basic(
                                  controller: _contentController,
                                  focusNode: _focusNode,
                                  // readOnly: false,
                                ),
                              ),
                            )),
                      ]),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // QuillToolbarFont(contentController: _contentController),
                    // QuillToolbarFormatting(
                    //     contentController: _contentController),
                    // QuillToolbarOther(contentController: _contentController),
                    QuillCustomToolbar(contentController: _contentController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
