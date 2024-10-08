import 'package:flutter/material.dart';
import 'task_model.dart'; // Import the Task model

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  String _selectedPriority = 'Low'; // Default priority
  List<Task> _tasks = [];

  void _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add(Task(name: _taskController.text.trim(), priority: _selectedPriority));
        _taskController.clear();
      });
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  List<Task> _sortTasksByPriority(List<Task> tasks) {
    List<Task> sortedTasks = List.from(tasks);
    sortedTasks.sort((a, b) => _getPriorityValue(b.priority).compareTo(_getPriorityValue(a.priority)));
    return sortedTasks;
  }

  int _getPriorityValue(String priority) {
    switch (priority) {
      case 'High':
        return 3;
      case 'Medium':
        return 2;
      case 'Low':
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Task> sortedTasks = _sortTasksByPriority(_tasks);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Task Input Field
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter Task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Priority Dropdown
                DropdownButton<String>(
                  value: _selectedPriority,
                  items: ['Low', 'Medium', 'High'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                ),
                SizedBox(width: 8),
                // Add Button
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          // Task List
          Expanded(
            child: sortedTasks.isEmpty
                ? Center(child: Text('No tasks added yet.'))
                : ListView.builder(
                    itemCount: sortedTasks.length,
                    itemBuilder: (context, index) {
                      final task = sortedTasks[index];
                      // Find the original index in the _tasks list
                      final originalIndex = _tasks.indexOf(task);
                      return ListTile(
                        title: Text(
                          task.name,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text('Priority: ${task.priority}'),
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) => _toggleTaskCompletion(originalIndex),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTask(originalIndex),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}