import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_note/widgets/edit_category_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_note/provider/note_provider.dart';
import 'package:ai_note/models/category.dart';

class CategoryWidget extends ConsumerWidget {
  const CategoryWidget(
      {super.key,
      required this.isSelected,
      required this.category,
      required this.index,
      required this.onTap});

  // final bool? isAll;
  final bool isSelected;
  final Category? category;
  final void Function(int index) onTap;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryNotifier = ref.watch(categoriesProvider.notifier);
    final categoryIndexNotifier = ref.watch(categoryIndexProvider.notifier);

    final notesList = ref.watch(notesProvider);
    final catList = ref.watch(categoriesProvider);
    // final catIndexList = ref.watch(categoryIndexProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          onTap(index);
          categoryIndexNotifier.setCategory(index);
          // ref.read(categoriesProvider.notifier).loadCategories();

          if (index == 0) {
            return;
          }
          ref
              .read(categoryContentProvider.notifier)
              .loadContent(notesList, catList, index);
        },
        onLongPress: () {
          if (index == 0) {
            return;
          }
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) {
                return EditCategoryWidget.edit(
                  newCategoryText: category!.name,
                  onEdit: (Category cat, String name) {
                    categoryNotifier.renameCategory(cat, name);
                  },
                  onDelete: categoryNotifier.deleteCategory,
                  category: category!,
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 100,
            ),
            child: Text(
              category?.name ?? 'All',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
