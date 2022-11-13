import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

const List<String> categoriesList = [
  "amusement_park",
  "aquarium",
  "art_gallery",
  "bowling_alley",
  "book_store",
  "casino",
  "night_club",
  "museum",
  "park",
  "spa",
  "tourist_attraction",
  "zoo",
  "cafe",
  "restaurant",
  "bar"
];

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Card(
        child: InkWell(
          splashColor: Colors.green.withAlpha(30),
          onTap: () => print('Card tapped.'),
          child: const SizedBox(width: 300, height: 100, child: Text("ee")),
        ),
      )
    ]));
  }
}
