import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// import 'package:markdown_editor_plus/markdown_editor_plus.dart' as mdplus;
import 'package:markdown_toolbar/markdown_toolbar.dart';

import 'package:ai_note/models/note.dart';
// import 'markdown_editor_controller.dart';

class NoteScreen extends StatefulWidget {
  NoteScreen({super.key, required this.note});

  final Note note;

  // void Function() onSelected;

  @override
  State<NoteScreen> createState() {
    return _NoteScreenState();
  }
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController _contentController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  String _markdownData = '';
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

  _saveNote() {}

  _changeMode() {
    setState(() {
      isEditing = !isEditing;
    });
    _getWidgetHeight();
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
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Title",
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _changeMode();
                print(_widgetHeight);
              },
              icon: isEditing ? Icon(Icons.done) : Icon(Icons.edit))
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
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0),
                child: SingleChildScrollView(
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
