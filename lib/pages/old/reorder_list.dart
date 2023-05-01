import 'package:flutter/material.dart';

class ReorderableListExample extends StatefulWidget {
  const ReorderableListExample({super.key});

  @override
  State<ReorderableListExample> createState() => _ReorderableListExampleState();
}

class _ReorderableListExampleState extends State<ReorderableListExample> {
  final List<String> names = ["Ano", "Bingo", "Cherry", "Dino", "Emily"];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Example"),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        padding: EdgeInsets.symmetric(
          horizontal: 6,
        ),
        // color: Colors.red,
        child: ReorderableListView(
          children: List.generate(
            names.length,
            (index) => Container(
              key: ValueKey(index),
              child: Row(
                children: [
                  Icon(Icons.menu),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.red[100],
                    ),
                    child: Text(
                      (index + 1).toString(),
                    ),
                  ),
                  Expanded(child: Text(names[index])),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete,
                    ),
                  )
                ],
              ),
            ),
          ),
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) {
              newIndex--;
            }

            final item = names.removeAt(oldIndex);
            //log(jsonEncode(item));
            names.insert(newIndex, item);

            setState(() {
              names;
            });
          },
        ),
      ),
    );
  }
}
