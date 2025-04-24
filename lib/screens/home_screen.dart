// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/task_item.dart';
import '../models/task_model.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final tasks = vm.tasks;

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
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet.\nTap + to add one!', textAlign: TextAlign.center))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, i) => TaskItem(
                task: tasks[i],
                onChanged: (val) => vm.toggleCompleted(tasks[i], val),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Task>(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          if (result != null) vm.addTask(result);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
