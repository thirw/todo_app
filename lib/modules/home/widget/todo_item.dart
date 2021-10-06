import 'package:flutter/material.dart';
import 'package:todo_app/data/todo_model.dart';

class TodoItem extends StatelessWidget {
  final String todoName;
  final onCheckTodo;

  const TodoItem({
    Key? key,
    required this.todoName,
    required this.onCheckTodo,
  }) : super(key: key);

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    //   ListTile(
    //   onTap: () {
    //     onCheckTodo(todo);
    //   },
    //   leading: CircleAvatar(
    //     child: Text(todoName.name![0]),
    //   ),
    //   title: Text(
    //     todoName,
    //     style: _getTextStyle(todo.checked!),
    //   ),
    // );
  }
}
