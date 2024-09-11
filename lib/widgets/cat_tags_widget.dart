import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_note/models/category.dart';
import 'package:ai_note/models/note.dart';

class CatTagsWidget extends StatelessWidget {
  const CatTagsWidget(
      {super.key,
      required this.category,
      required this.deleteCat,
      required this.note});

  final Category category;
  final Note note;
  final void Function(Category cat, Note note) deleteCat;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        left: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 100,
            ),
            child: Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: 16),
            ),
          ),
          IconButton(
              onPressed: () {
                deleteCat(category, note);
              },
              icon: const Icon(
                Icons.close,
                size: 17,
              ))
        ],
      ),
    );
  }
}
