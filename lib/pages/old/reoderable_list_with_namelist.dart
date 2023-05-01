import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter/utils/old/database_helper_v1.dart';

class ReorderableWithNameList extends StatefulWidget {
  const ReorderableWithNameList({super.key});

  @override
  State<ReorderableWithNameList> createState() =>
      _ReorderableWithNameListState();
}

class _ReorderableWithNameListState extends State<ReorderableWithNameList> {
  final NameListProvider nameListProvider = NameListProvider();

  List<Map<String, dynamic>> namesList = [];

  void fetchNameList() async {
    // Initializes the database
    await nameListProvider.init();

    // Clears the list and add the recieved data to the list.
    namesList.clear();
    namesList.addAll(await nameListProvider.getNameList());

    // Updates list.
    setState(() {
      namesList;
    });
  }

  // This is used to update the list when the position is changed.
  void updateAllList() async {
    setState(() {
      namesList;
    });

    for (var name in namesList) {
      int index = namesList.indexOf(name);
      // copies the prev data of name then sets a new position according to the index.
      name = {...name, "position": (index + 1)};

      nameListProvider.update(name);
    }

    log("Updating");
    namesList.clear();
    namesList.addAll(await nameListProvider.getNameList());
    setState(() {
      namesList;
    });
  }

  // calls on screen call
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNameList();
  }

  // calls when screen is closed.
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
            content: TextFormField(
              validator: (value) {
                if (value == null || value == "") {
                  return "Please Insert Name";
                }
              },
              onChanged: (value) {},
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
                    log("What Happed");

                    var item = await nameListProvider.insert({
                      "name": textEditingController.text,
                      "position": position
                    });

                    if (item != null) {
                      namesList.clear();
                      namesList.addAll(item);

                      log(jsonEncode(item));

                      setState(() {
                        namesList;
                      });
                    }

                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please Insert Name'),
                      duration: Duration(milliseconds: 30),
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Sqflite Example"),
        actions: [
          IconButton(
            onPressed: () {
              _displayTextInputDialog(context, (namesList.length + 1));
            },
            icon: Icon(Icons.add),
          ),
        ],
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
            namesList!.length,
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
                  Expanded(
                      child: Text(
                          "${namesList[index]["name"]} - ${namesList[index]["position"]}")),
                  IconButton(
                    onPressed: () async {
                      await nameListProvider.delete(namesList[index]["_id"]);
                      namesList.remove(namesList[index]);
                      log("AK");

                      log(namesList.toString());

                      updateAllList();
                    },
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

            final item = namesList.removeAt(oldIndex);
            //log(jsonEncode(item));
            namesList.insert(newIndex, item);

            updateAllList();
          },
        ),
      ),
    );
  }
}
