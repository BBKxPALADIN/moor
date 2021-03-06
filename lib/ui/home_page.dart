import 'package:flutter/material.dart';
import 'widget/new_task_input_widget.dart';
import '../data/moor_database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          _buildCompletedOnlySwitch(),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildTaskList(context)),
          const NewTaskInput(),
        ],
      ),
    );
  }

  Row _buildCompletedOnlySwitch() {
    return Row(
      children: [
        const Text('Completed only'),
        Switch(
          value: showCompleted,
          activeColor: Colors.white,
          onChanged: (newValue) {
            setState(() {
              showCompleted = newValue;
            });
          },
        ),
      ],
    );
  }

  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    final dao = Provider.of<TaskDao>(context, listen: false);
    return StreamBuilder(
        stream: showCompleted?dao.watchCompletedTasks(): dao.watchAllTasks(),
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          final tasks = snapshot.data ?? [];
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, index) {
              final itemTask = tasks[index];
              return _buildListItem(itemTask, dao);
            },
          );
        });
  }

  Widget _buildListItem(Task itemTask, TaskDao dao) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => dao.deleteTask(itemTask),
        )
      ],
      child: CheckboxListTile(
        title: Text(itemTask.name),
        subtitle: Text(itemTask.dueDate?.toString() ?? 'No date'),
        value: itemTask.completed,
        onChanged: (newValue) =>
            dao.updateTask(itemTask.copyWith(completed: newValue)),
      ),
    );
  }
}
