import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_flutter/utils/old/database_helper.dart';

class ReorderableListWithSqflite extends StatefulWidget {
  const ReorderableListWithSqflite({super.key});

  @override
  State<ReorderableListWithSqflite> createState() =>
      _ReorderableListWithSqfliteState();
}

class _ReorderableListWithSqfliteState
    extends State<ReorderableListWithSqflite> {
  final dbHelper = DatabaseHelper();

  List names = [];

  // homepage layout
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      WidgetsFlutterBinding.ensureInitialized();
      await dbHelper.init();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
        actions: [
          IconButton(
            onPressed: () async {
              List nameList = await _query();
              setState(() {
                names = nameList;
              });

              log(jsonEncode(names));
            },
            icon: Icon(
              Icons.edit_attributes,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...List.generate(names.length, (index) {
              return Container(
                child: Text(names[index]['name']),
              );
            }),
            ElevatedButton(
              onPressed: _insert,
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('query'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('delete'),
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.name: "suabash",
    };
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  Future<List> _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
    return allRows;

    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.id: 1,
      DatabaseHelper.name: 'Mary',
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }
}
