import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../model/taskmodel.dart';
import '../routing/app_pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> tasks = [];
  List<TaskModel> _filteredTasks = [];
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _filteredTasks = tasks;
    _searchController.addListener(_filterTasks);
  }
  @override
  void dispose() {
    _searchController.removeListener(_filterTasks);
    _searchController.dispose();
    super.dispose();
  }
  void _addTask(TaskModel task) {
    setState(() {
      tasks.add(task);
      _filterTasks();
    });
  }
  void _deleteTask(int index) {
    final taskToDelete = _filteredTasks[index];
    final originalIndex = tasks.indexOf(taskToDelete);

    if (originalIndex != -1) {
      setState(() {
        tasks.removeAt(originalIndex);
        _filterTasks();
      });
    }
  }

  void _toggleTask(int index) {
    final taskToToggle = _filteredTasks[index];
    final originalIndex = tasks.indexOf(taskToToggle);

    if (originalIndex != -1) {
      setState(() {
        tasks[originalIndex].isCompleted = !tasks[originalIndex].isCompleted;
      });
    }
  }

  void _filterTasks() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredTasks = tasks;
      } else {
        _filteredTasks = tasks.where((task) {
          return task.title.toLowerCase().contains(query);
        }).toList();
      }
    });
  }
  Widget _buildTaskItem(BuildContext context, TaskModel item, int index) {
    final bool isCompleted = item.isCompleted;
    final Color indicatorColor = isCompleted ? Colors.green : const Color(0xFF4285F4);
    final double indicatorHeight = (item.description != null && item.description!.isNotEmpty) ? 75.0 : 50.0;
    final TextDecoration textDecoration = isCompleted ? TextDecoration.lineThrough : TextDecoration.none;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: indicatorHeight,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              leading: Checkbox(
                value: isCompleted,
                onChanged: (value) => _toggleTask(index),
                activeColor: indicatorColor,
                side: const BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? Colors.grey[700] : Colors.black,
                ),
              ),
              subtitle: item.description != null && item.description!.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  item.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              )
                  : null,
              trailing: IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.redAccent.withOpacity(0.7)),
                onPressed: () => _deleteTask(index),
              ),
              contentPadding: const EdgeInsets.only(left: 0, right: 10),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final List<TaskModel> listToDisplay = _filteredTasks;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF4285F4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TaskMate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white, size: 30),
                      onPressed: () async {
                        final task =
                        await context.pushNamed(AppPages.addtaskscreen);

                        if (task != null && task is TaskModel) {
                          _addTask(task);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Search tasks by title",
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Text(
                    "Today's Tasks",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (tasks.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        "No Tasks Yet",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  )
                else if (listToDisplay.isEmpty)
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 60,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "No tasks match your search.",
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      itemCount: listToDisplay.length,
                      itemBuilder: (context, index) {
                        final item = listToDisplay[index];
                        return _buildTaskItem(context, item, index);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}