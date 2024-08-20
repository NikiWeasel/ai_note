import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ai_note/models/category.dart';

class EditCategoryWidget extends StatefulWidget {
  const EditCategoryWidget._internal(
      {super.key,
      this.newCategoryText,
      this.onSave,
      this.onDelete,
      this.category,
      this.onEdit});

  final String? newCategoryText;
  final Category? category;
  final void Function(String name)? onSave;
  final void Function(Category category, String newName)? onEdit;
  final void Function(Category cat)? onDelete;

  factory EditCategoryWidget.create({
    Key? key,
    required String newCategoryText,
    required void Function(String name) onSave,
  }) {
    return EditCategoryWidget._internal(
      key: key,
      newCategoryText: newCategoryText,
      onSave: onSave,
    );
  }

  // Именованный конструктор для редактирования существующей категории
  factory EditCategoryWidget.edit({
    Key? key,
    required String newCategoryText,
    required Category category,
    required void Function(Category category, String newName) onEdit,
    required void Function(Category cat) onDelete,
  }) {
    return EditCategoryWidget._internal(
      key: key,
      category: category,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }

  @override
  State<EditCategoryWidget> createState() => _EditCategoryWidgetState();
}

class _EditCategoryWidgetState extends State<EditCategoryWidget> {
  late final _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.text = widget.newCategoryText ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void openAlert() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Warning'),
              content: Text(
                'Delete category "${widget.newCategoryText}"?',
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Yes'),
                  onPressed: () {
                    widget.onDelete!(widget.category!);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      // Navigator.pop(context);
    }

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.newCategoryText != null
                  ? 'Create Category'
                  : 'Edit Category',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _controller,
            ),
            SizedBox(height: 16.0),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.newCategoryText != null
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: () {
                          Navigator.pop(context);

                          openAlert();
                        },
                        child: Text(
                          'Delete',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 16),
                        ),
                      ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if ((widget.newCategoryText == _controller.text) ||
                        (widget.newCategoryText == null &&
                            _controller.text == '')) {
                      return;
                    }
                    if (widget.onSave != null) {
                      widget.onSave!(_controller.text);
                    }
                    if (widget.onEdit != null) {
                      widget.onEdit!(widget.category!, _controller.text);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
