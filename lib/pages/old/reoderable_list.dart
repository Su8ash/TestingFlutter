import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter/utils/old/database_helper_v2.dart';

class MyReorderableList extends StatefulWidget {
  const MyReorderableList({super.key});

  @override
  State<MyReorderableList> createState() => _MyReorderableListState();
}

class _MyReorderableListState extends State<MyReorderableList> {
  final NameListProvider nameListProvider = NameListProvider();

  final List<String> names = ["Ani", "Bingo", "Cherry", "Dino"];

  final List<Map<String, dynamic>> namesList = [];

  reorderList(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex--;
    }

    setState(() {
      final item = namesList.removeAt(oldIndex);
      namesList.insert(newIndex, item);
    });
    updateAllList();
  }

  void updateAllList() async {
    setState(() {
      namesList;
    });

    for (var name in namesList) {
      int index = namesList.indexOf(name);

      name = {
        ...name,
        nameListProvider.columnPosition: (index + 1),
      };

      nameListProvider.update(name);
    }

    namesList.clear();
    namesList.addAll(await nameListProvider.getNameList());

    setState(() {
      namesList;
    });
  }

  void fetchNameList() async {
    await nameListProvider.init();

    namesList.clear();
    namesList.addAll(await nameListProvider.getNameList());

    setState(() {
      namesList;
    });

    log(jsonEncode(namesList));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNameList();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    nameListProvider.close();
  }

  // Displays a dialog box.
  Future<void> _displayTextInputDialog(
      BuildContext context, int position) async {
    TextEditingController textEditingController =
        TextEditingController(text: "Position $position");

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Name'),
            content: TextField(
              controller: textEditingController,
              decoration:
                  const InputDecoration(hintText: "Please Insert Your name"),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (textEditingController.text != "") {
                    var item = await nameListProvider.insert({
                      "name": textEditingController.text,
                      "position": position
                    });

                    if (item != null) {
                      namesList.clear();
                      namesList.addAll(item);
                    }

                    // setState(() {
                    //   namesList;
                    // });

                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please Insert Name'),
                      duration: Duration(milliseconds: 300),
                    ));
                  }
                },
                child: Text("Add"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("SQFLite Example"),
          actions: [
            IconButton(
              onPressed: () {
                _displayTextInputDialog(context, (namesList.length + 1));
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ReorderableListView(
                  shrinkWrap: true,
                  onReorder: ((oldIndex, newIndex) {
                    // To do - When reoder
                    log(oldIndex.toString());
                    log(newIndex.toString());
                    reorderList(oldIndex, newIndex);
                  }),
                  children: [
                    ...List.generate(
                      namesList.length,
                      (index) => Container(
                        key: ValueKey(index),
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.menu),
                            ),
                            Container(
                              margin: EdgeInsets.all(4),
                              padding: EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Text(
                                "${namesList[index][nameListProvider.columnName]} - ${namesList[index][nameListProvider.columnPosition]}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await nameListProvider.delete(namesList[index]
                                    [nameListProvider.columnId]);

                                namesList.remove(namesList[index]);
                                updateAllList();
                              },
                              icon: Icon(
                                Icons.delete,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
