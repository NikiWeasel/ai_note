// import 'package:ai_note/provider/categories_provider.dart';
import 'package:ai_note/widgets/category_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_note/provider/note_provider.dart';
import 'edit_category_widget.dart';

class HoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: 50));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Categories extends ConsumerStatefulWidget {
  const Categories({super.key});

  // final int categoriesLength;

  @override
  ConsumerState<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends ConsumerState<Categories> {
  // late List<bool> isSelectedList;
  late TextEditingController _controller;
  late final categoriesListNotify;

  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    categoriesListNotify =
        ref.read(categoriesProvider.notifier).loadCategories();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesList = ref.watch(categoriesProvider);
    final categoriesNotifier = ref.watch(categoriesProvider.notifier);

    List<bool> isSelectedList;
    isSelectedList = List.generate(categoriesList.length, (_) => false);
    isSelectedList.insert(activeIndex, true);

    void addNewCategory() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => EditCategoryWidget.create(
                newCategoryText: _controller.text,
                onSave: (String name) async {
                  bool isAvailible =
                      await categoriesNotifier.insertCategory(name);
                  if (!isAvailible) {
                    return;
                  }
                },
              ));
      isSelectedList.add(false);
    }

    Widget addButton = Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          //Theme.of(context).colorScheme.primaryContainer
          borderRadius: BorderRadius.circular(50)),
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        onPressed: () {
          addNewCategory();
        },
      ),
    );

    void onTap(int index) {
      setState(() {
        activeIndex = index;
      });
    }

    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 25,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  ToggleButtons(
                    // selectedColor: Theme.of(context).colorScheme.,
                    borderWidth: 0,
                    // splashColor: Colors.yellow,
                    renderBorder: false,
                    isSelected: isSelectedList,
                    // selectedColor: Colors.amber,
                    // renderBorder: false,
                    fillColor: Colors.transparent,
                    children: <Widget>[
                      CategoryWidget(
                        isSelected: isSelectedList[0],
                        category: null,
                        index: 0,
                        onTap: onTap,
                      ),
                      for (int i = 1; i < isSelectedList.length; i++)
                        CategoryWidget(
                          isSelected: isSelectedList[i],
                          category: categoriesList[i - 1],
                          index: i,
                          onTap: onTap,
                        ),
                    ],
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(bottom: 4, right: 8, child: addButton),
      ],
    );
  }
}
