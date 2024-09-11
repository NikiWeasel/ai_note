import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color currentColor = Color(0xff8000a1);
    int savedColor = 0xff8000a1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: CircleAvatar(
                    backgroundColor: Color(savedColor),
                  )),
              Text(
                'Seed theme color',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          )
        ],
      ),
    );
  }
}
