import 'package:flutter/cupertino.dart';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ai_note/models/category.dart';

class EditCategoryWidget extends StatefulWidget {
  const EditCategoryWidget(
      {super.key, required this.text, required this.onSave});

  final String? text;
  final void Function(String name) onSave;

  @override
  State<EditCategoryWidget> createState() => _EditCategoryWidgetState();
}

class _EditCategoryWidgetState extends State<EditCategoryWidget> {
  late final _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.text = widget.text ?? '';
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
                'Delete category "${widget.text}"?',
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
                    //TODO логика удаления
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.text == null ? 'Creare Category' : 'Edit Category',
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
                widget.text == null
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
                    if ((widget.text == _controller.text) ||
                        (widget.text == null && _controller.text == '')) {
                      return;
                    }
                    widget.onSave(_controller.text);
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
