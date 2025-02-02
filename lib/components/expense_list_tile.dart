import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseListTile extends StatelessWidget {
  final String title;
  final String trailing;

  final void Function(BuildContext)? onEditPressed;
  final void Function(BuildContext)? onDeletePressed;

  const ExpenseListTile(
      {super.key,
      required this.title,
      required this.trailing,
      required this.onEditPressed,
      required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // Edit
          SlidableAction(
            onPressed: onEditPressed,
            icon: Icons.settings,
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          // Delete
          SlidableAction(
            onPressed: onDeletePressed,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        trailing: Text(trailing),
      ),
    );
  }
}
