import 'package:flutter/material.dart';
import 'package:task_management_app/widget/task_item_widget.dart';
import '../model/task_model.dart';
import '../service/shared_pref.dart';
import 'task_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<TaskModel> tasks = [];
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = "";

  List<TaskModel> get filteredTasks {
    if (searchQuery.trim().isEmpty) {
      return tasks;
    }

    return tasks.where((task) {
      return task.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((task) => task.isCompleted).length;

  Future<void> loadTasks() async {
    tasks = await SharedPrefService.loadTasks();
    setState(() {});
  }

  Future<void> saveTasks() async {
    await SharedPrefService.saveTasks(tasks);
  }

  Future<void> addTask() async {
    final TaskModel? task = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTaskView()),
    );

    if (task != null) {
      setState(() {
        tasks.add(task);
      });

      saveTasks();
    }
  }

  Future<void> editTask(int index) async {
    final TaskModel? updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditTaskView(task: tasks[index])),
    );

    if (updatedTask != null) {
      setState(() {
        tasks[index] = updatedTask;
      });

      saveTasks();
    }
  }

  Future<void> deleteTask(int index) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      setState(() {
        tasks.removeAt(index);
      });

      await saveTasks();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task deleted successfully")),
        );
      }
    }
  }

  void toggleCompleted(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });

    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Manager"), centerTitle: true),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 5),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search tasks",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            searchQuery = "";
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Total Tasks",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$totalTasks",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      const Text(
                        "Completed",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$completedTasks",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Text(
                      searchQuery.isEmpty
                          ? "No Tasks Available"
                          : "No tasks found",
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      // Find the original task index
                      final originalIndex = tasks.indexOf(task);
                      return TaskItemWidget(
                        task: task,
                        onEdit: () => editTask(originalIndex),
                        onDelete: () => deleteTask(originalIndex),
                        onChanged: (_) => toggleCompleted(originalIndex),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
