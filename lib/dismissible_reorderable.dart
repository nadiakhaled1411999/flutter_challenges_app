import 'package:flutter/material.dart';

class Challenge1DismissibleReorderable extends StatefulWidget {
  static const routeName = '/challenge1';
  const Challenge1DismissibleReorderable({super.key});

  @override
  State<Challenge1DismissibleReorderable> createState() => _Challenge1DismissibleReorderableState();
}

class _Challenge1DismissibleReorderableState extends State<Challenge1DismissibleReorderable> {
  List<_TaskItem> tasks = [
    _TaskItem('Buy groceries'),
    _TaskItem('Complete Flutter project'),
    _TaskItem('Call a friend'),
  ];

  void _deleteTask(int index) {
    final removedTask = tasks[index];
    setState(() {
      tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${removedTask.title}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              tasks.insert(index, removedTask);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenge 1: Task Manager')),
      body: ReorderableListView.builder(
        itemCount: tasks.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = tasks.removeAt(oldIndex);
            tasks.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: ValueKey(task.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: Text('Are you sure you want to delete "${task.title}"?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
                  ],
                ),
              );
            },
            onDismissed: (direction) => _deleteTask(index),
            child: Material(
              // Material needed so the Reorderable drag handle ripple looks correct
              child: ListTile(
                key: ValueKey('tile_${task.id}'),
                leading: Checkbox(
                  value: task.completed,
                  onChanged: (val) {
                    setState(() {
                      task.completed = val ?? false;
                    });
                  },
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                trailing: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            tasks.add(_TaskItem('New task ${DateTime.now().millisecondsSinceEpoch}'));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskItem {
  final String id = UniqueKey().toString();
  final String title;
  bool completed;

  _TaskItem(this.title, {this.completed = false});
}
