import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoContent extends StatelessWidget {
  const NoContent({super.key, required this.onNewNote, required this.onAiChat});

  final void Function() onNewNote;
  final void Function() onAiChat;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'No file is open',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 35),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.add),
                onPressed: onNewNote,
                label: Text('Create a new note',
                    style: Theme.of(context).textTheme.titleLarge!),
              ),
              TextButton.icon(
                icon: const Icon(Icons.file_open),
                onPressed: () {},
                label: Text('Open note',
                    style: Theme.of(context).textTheme.titleLarge!),
              ),
              TextButton.icon(
                icon: const Icon(Icons.accessible_forward_sharp),
                onPressed: onAiChat,
                label: Text('Open AI Assistant',
                    style: Theme.of(context).textTheme.titleLarge!),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
