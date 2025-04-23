import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/task_item.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];

  void _addTask(Task task) {
    setState(() {
      _tasks.insert(0, task);
    });
  }

  void _toggleCompleted(Task task, bool? checked) {
    setState(() {
      task.isCompleted = checked ?? false;
    });
  }

  Future<void> _goToAdd() async {
    final result = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (result != null) {
      _addTask(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet.\nTap + to add one!',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (_, i) => TaskItem(
                task: _tasks[i],
                onChanged: (val) => _toggleCompleted(_tasks[i], val),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
