import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';
import '../../data/moor_database.dart';
import 'package:provider/provider.dart';

class NewTaskInput extends StatefulWidget {
  const NewTaskInput({Key key}) : super(key: key);

  @override
  _NewTaskInputState createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  DateTime newTaskDate;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTextField(context),
          _buildDateButton(context),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Task Name'),
        onSubmitted: (inputName) {
          final dao = Provider.of<TaskDao>(context,listen: false);
          final task = TasksCompanion(
            name: Value(inputName),
            dueDate: Value(newTaskDate),
          );
          dao.insertTask(task);
          resetValuesAfterSubmit();
        },
      ),
    );
  }

  IconButton _buildDateButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.calendar_today),
      onPressed: () async {
        newTaskDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010),
          lastDate: DateTime(2050),
        );
      },
    );
  }

  void resetValuesAfterSubmit() {
    setState(() {
      newTaskDate = null;
      controller.clear();
    });
  }
}
