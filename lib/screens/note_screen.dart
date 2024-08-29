import 'package:ai_note/widgets/cat_tags_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_toolbar/markdown_toolbar.dart';
import 'package:ai_note/models/note.dart';
import 'package:ai_note/provider/note_provider.dart';

import 'package:ai_note/models/category.dart';

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
  TextEditingController _contentController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  List<Category> catList = [];

  // String _markdownData = '';
  var _focusNode = FocusNode();
  bool isEditing = true;

  final GlobalKey _widgetKey = GlobalKey();
  double _widgetHeight = 0.0;

  String description = 'My great package';

  void _getWidgetHeight() {
    final RenderBox renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox;
    final height = renderBox.size.height;
    setState(() {
      _widgetHeight = height;
    });
  }

  // _saveNote() {}

  _changeMode() {
    setState(() {
      isEditing = !isEditing;
    });
    _getWidgetHeight();
  }

  void setCatList(List<Category> allCatList) {
    catList = [];

    for (var category in allCatList) {
      var notesList = category.notesList ?? [];

      if (notesList.contains(widget.note.id)) {
        catList.add(category);
      }
    }
    // print('');
  }

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.note.content;
    _titleController.text = widget.note.title;
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

    // categoriesList.where((cat) =>
    //     cat.notesList.where((noteid) => noteid == widget.note.id).isNotEmpty);

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
              onPressed: () {
                _changeMode();
                // print(_widgetHeight);
              },
              icon: isEditing ? const Icon(Icons.done) : const Icon(Icons.edit))
        ],
      ),
      // drawer: ...,
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) return;
          Navigator.of(context).pop(Note(
              title: _titleController.text, content: _contentController.text));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            for (var cat in catList)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CatTagsWidget(
                                  category: cat,
                                  deleteCat: (cat, note) {
                                    setState(() {
                                      print('pressed');
                                      categoriesNotifier.deleteCatNoteLinks(
                                          cat, note);
                                    });
                                  },
                                  note: widget.note,
                                ),
                              ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ),
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
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: isEditing
                            ? SizedBox(
                                height: 500,
                                child: TextField(
                                  key: _widgetKey,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter Markdown text…",
                                  ),
                                  controller: _contentController,
                                  focusNode: _focusNode,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(),
                                ),
                              )
                            : Align(
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                  height: _widgetHeight + 100,
                                  child: InkWell(
                                    onDoubleTap: _changeMode,
                                    splashColor: Colors.transparent,
                                    child: Markdown(
                                        // controller: _controller,
                                        data: _contentController.text),
                                  ),
                                ),
                              ),
                      ),
                    ]),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: MarkdownToolbar(
                // If you set useIncludedTextField to true, remove
                // a) the controller and focusNode fields below and
                // b) the TextField outside below widget
                useIncludedTextField: false,
                controller: _contentController,
                focusNode: _focusNode,
              ),
            )
          ],
        ),
      ),
    );
  }
}
