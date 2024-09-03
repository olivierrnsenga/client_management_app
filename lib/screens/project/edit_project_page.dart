import 'package:client_management_app/blocs/project/project_bloc.dart';
import 'package:client_management_app/blocs/project/project_event.dart';
import 'package:client_management_app/models/project/project.dart';
import 'package:client_management_app/models/project/project_client.dart';
import 'package:client_management_app/models/project/project_lawyer.dart';
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
  late TextEditingController _statusIDController;

  final List<ProjectClient> _selectedProjectClients = [];
  final List<ProjectLawyer> _selectedProjectLawyers = [];

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
    _statusIDController =
        TextEditingController(text: widget.project.statusID.toString());

    // Initialize with existing projectClients and projectLawyers
    _selectedProjectClients.addAll(widget.project.projectClients);
    _selectedProjectLawyers.addAll(widget.project.projectLawyers);
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
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
        projectClients: _selectedProjectClients,
        projectLawyers: _selectedProjectLawyers,
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
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                children: _selectedProjectClients.map((projectClient) {
                  return Chip(
                    label: Text(
                        'Client ${projectClient.client.firstName} ${projectClient.client.lastName}'),
                    onDeleted: () {
                      setState(() {
                        _selectedProjectClients.remove(projectClient);
                      });
                    },
                  );
                }).toList(),
              ),
              // Similarly add Autocomplete for selecting and adding clients

              const SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                children: _selectedProjectLawyers.map((projectLawyer) {
                  return Chip(
                    label: Text(
                        'Lawyer ${projectLawyer.lawyer.firstName} ${projectLawyer.lawyer.lastName}'),
                    onDeleted: () {
                      setState(() {
                        _selectedProjectLawyers.remove(projectLawyer);
                      });
                    },
                  );
                }).toList(),
              ),
              // Similarly add Autocomplete for selecting and adding lawyers

              const SizedBox(height: 16.0),
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
