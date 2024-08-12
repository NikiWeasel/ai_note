// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:ai_note/models/note.dart';
// import 'package:ai_note/screens/note_screen.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/tap_bounce_container.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
//
// // List<Note> notes = [
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// //   Note(title: '1', content: 'content1'),
// // ];
//
// class MainDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//         child: Column(
//       // mainAxisSize: MainAxisSize.max,
//       // crossAxisAlignment: CrossAxisAlignment.center,
//       // mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Container(
//           width: double.infinity,
//           // color: Colors.white,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             color: Theme.of(context).colorScheme.primaryContainer,
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 120,
//                 child: DrawerHeader(
//                     child: Expanded(
//                   child: Text(
//                     'AI Chats',
//                     style: Theme.of(context).textTheme.titleLarge!,
//                   ),
//                 )),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () {},
//                 label: Text(
//                   'New AI Chat',
//                 ),
//                 icon: Icon(Icons.add),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//               itemCount: notes.length,
//               itemBuilder: (ctx, index) => Padding(
//                     padding: const EdgeInsets.only(
//                         top: 4.0, bottom: 4, left: 8, right: 8),
//                     child: Card(
//                       color: Theme.of(context).colorScheme.secondaryContainer,
//                       child: ListTile(
//                         title: Text(
//                           notes[index].title,
//                         ),
//                         subtitle: Text(notes[index].content),
//                       ),
//                     ),
//                   )),
//         ),
//       ],
//     ));
//   }
// }
