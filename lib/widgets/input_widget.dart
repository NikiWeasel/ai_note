import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({super.key, required this.onPressed, required this.icon});

  // final TextEditingController _controller;
  final void Function(String text) onPressed;

  // final void Function(String text) onPressed;//TODO сделать просто иконку слева и выполнять функцию просто по кнопке на клаве
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Container(
      // margin: EdgeInsets.all(0.8),
      // padding: EdgeInsets.all(0.8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.black54,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16, right: 16),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
              controller: _controller,
            )),
            IconButton(
                onPressed: () {
                  onPressed(_controller.text);
                  _controller.clear();
                },
                icon: icon)
          ],
        ),
      ),
    );
  }
}
