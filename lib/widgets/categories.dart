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

  @override
  ConsumerState<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends ConsumerState<Categories> {
  late TextEditingController _controller;
  late List<bool> isSelectedList;
  late final categoriesListNotify;

  @override
  void initState() {
    // TODO: implement initState
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

    isSelectedList = List.generate(categoriesList.length, (_) => false);
    print(categoriesList.length);
    isSelectedList.insert(0, true);

    void addNewCategory() async {
      final ss = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => EditCategoryWidget(
                text: null,
                onSave: (String name) {}, //TODO добавить логику создания
              ));
      // print(isSelectedList);
      print(ss);
      categoriesNotifier.insertCategory('New Category');
      isSelectedList.add(false);

      print(categoriesList);
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
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (ctx) => CategoryScreen()));
        },
      ),
    );

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
                    borderWidth: 0,
                    // splashColor: Colors.yellow,
                    renderBorder: false,
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelectedList.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            isSelectedList[buttonIndex] =
                                !isSelectedList[buttonIndex];
                          } else {
                            isSelectedList[buttonIndex] = false;
                          }
                        }
                      });
                    },
                    isSelected: isSelectedList,
                    // selectedColor: Colors.amber,
                    // renderBorder: false,
                    fillColor: Colors.transparent,
                    children: <Widget>[
                      CategoryWidget(
                          isSelected: isSelectedList[0], text: 'All'),
                      for (int i = 0; i < categoriesList.length; i++)
                        CategoryWidget(
                            isSelected: isSelectedList[i + 1],
                            text: categoriesList[i].name),
                    ],
                  ),
                  SizedBox(
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
