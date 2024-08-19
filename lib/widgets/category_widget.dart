import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_note/widgets/edit_category_widget.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
      {super.key, required this.isSelected, required this.text});

  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: InkWell(
        onLongPress: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) {
                return EditCategoryWidget(
                  text: text,
                  onSave:
                      (String name) {}, //TODO добавить логику редактирования
                );
              });
        },
        child: Container(
          height: 45,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              // border: Border.all(
              //     color: Theme.of(context).colorScheme.onSurface, width: 2),
              color: isSelected
                  ? Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.8) //TODO поменять цвет выбранного
                  : Colors.black54,
              borderRadius: BorderRadius.circular(16)),
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
