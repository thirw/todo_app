import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/todo_model.dart';
import 'package:todo_app/modules/home/widget/todo_item.dart';

class HomeView extends StatefulWidget {
  final String title;

  const HomeView({Key? key, required this.title}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _textFieldController = TextEditingController();
  List _todos = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void _onAddTodo() {
    if (_textFieldController.text.isEmpty) return;
    setState(() {
      _todos.add(TodoModel(name: _textFieldController.text, checked: false));
    });
    saveData();
    _textFieldController.clear();
  }

  void _onRemoveTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    saveData();
  }

  void saveData() async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('data', jsonEncode(_todos));
  }

  void loadData() async {
    final _prefs = await SharedPreferences.getInstance();
    final data = _prefs.getString('data');
    final todoData = jsonDecode(data!);
    List<TodoModel> response = [];
    for (final item in todoData) {
      response.add(TodoModel.fromJson(item));
    }
    setState(() {
      _todos = response;
    });
  }

  Future<void> _onShowModal() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add new Todo'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Input new todo'),
            ),
            actions: [
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _onAddTodo();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _onShowModal,
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _todos[index];
            return Dismissible(
              key: Key(item.name!),
              child: CheckboxListTile(
                title: Text(item.name!),
                value: item.checked,
                onChanged: (value) {
                  setState(() {
                    item.checked = value;
                  });
                  saveData();
                },
              ),
              secondaryBackground: Container(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      Text('Delete', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                color: Colors.red,
              ),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirmation"),
                      content: const Text("Are you sure to delete this task?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Confirm")),
                      ],
                    );
                  },
                );
              },
              onDismissed: (_) {
                _onRemoveTodo(index);
              },
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
            );
          }),
    );
  }
}
