import 'package:client_management_app/blocs/project/project_bloc.dart';
import 'package:client_management_app/blocs/project/project_event.dart';
import 'package:client_management_app/models/project/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProjectPage extends StatefulWidget {
  final Project project;

  const EditProjectPage({super.key, required this.project});

  @override
  // ignore: library_private_types_in_public_api
  _EditProjectPageState createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _projectNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _clientIDController;
  late TextEditingController _lawyerIDController;
  late TextEditingController _statusIDController;

  @override
  void initState() {
    super.initState();
    _projectNameController =
        TextEditingController(text: widget.project.projectName);
    _descriptionController =
        TextEditingController(text: widget.project.description);
    _startDateController =
        TextEditingController(text: widget.project.startDate.toIso8601String());
    _endDateController =
        TextEditingController(text: widget.project.endDate.toIso8601String());
    _clientIDController =
        TextEditingController(text: widget.project.clientID.toString());
    _lawyerIDController =
        TextEditingController(text: widget.project.lawyerID.toString());
    _statusIDController =
        TextEditingController(text: widget.project.statusID.toString());
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _clientIDController.dispose();
    _lawyerIDController.dispose();
    _statusIDController.dispose();
    super.dispose();
  }

  void _saveProject() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedProject = widget.project.copyWith(
        projectName: _projectNameController.text,
        description: _descriptionController.text,
        startDate: DateTime.parse(_startDateController.text),
        endDate: DateTime.parse(_endDateController.text),
        clientID: int.parse(_clientIDController.text),
        lawyerID: int.parse(_lawyerIDController.text),
        statusID: int.parse(_statusIDController.text),
      );
      context.read<ProjectBloc>().add(UpdateProject(project: updatedProject));
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Project'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProject,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _projectNameController,
                decoration: const InputDecoration(labelText: 'Project Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter project name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter description' : null,
              ),
              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please select start date' : null,
                onTap: () => _selectDate(context, _startDateController),
              ),
              TextFormField(
                controller: _endDateController,
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please select end date' : null,
                onTap: () => _selectDate(context, _endDateController),
              ),
              TextFormField(
                controller: _clientIDController,
                decoration: const InputDecoration(labelText: 'Client ID'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter client ID' : null,
              ),
              TextFormField(
                controller: _lawyerIDController,
                decoration: const InputDecoration(labelText: 'Lawyer ID'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter lawyer ID' : null,
              ),
              TextFormField(
                controller: _statusIDController,
                decoration: const InputDecoration(labelText: 'Status ID'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter status ID' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
