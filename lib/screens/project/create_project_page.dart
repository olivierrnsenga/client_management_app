import 'package:client_management_app/blocs/client/client_bloc.dart';
import 'package:client_management_app/blocs/client/client_event.dart';
import 'package:client_management_app/blocs/client/client_state.dart';
import 'package:client_management_app/blocs/lawyer/lawyer_bloc.dart';
import 'package:client_management_app/blocs/lawyer/lawyer_event.dart';
import 'package:client_management_app/blocs/lawyer/lawyer_state.dart';
import 'package:client_management_app/blocs/project/project_bloc.dart';
import 'package:client_management_app/blocs/project/project_event.dart';
import 'package:client_management_app/models/client/client.dart';
import 'package:client_management_app/models/lawyer/lawyer.dart';
import 'package:client_management_app/models/project/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateProjectPageState createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _projectNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _clientIDController;
  late TextEditingController _lawyerIDController;
  late TextEditingController _statusIDController;
  int? _selectedClientID;
  int? _selectedLawyerID;

  @override
  void initState() {
    super.initState();
    _projectNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _clientIDController = TextEditingController();
    _lawyerIDController = TextEditingController();
    _statusIDController = TextEditingController();
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
      final newProject = Project(
        projectName: _projectNameController.text,
        description: _descriptionController.text,
        startDate: DateTime.parse(_startDateController.text),
        endDate: DateTime.parse(_endDateController.text),
        clientID: _selectedClientID!,
        lawyerID: _selectedLawyerID!,
        statusID: int.parse(_statusIDController.text),
      );
      context.read<ProjectBloc>().add(AddProject(project: newProject));
      Navigator.pop(context); // Go back to the project list page after saving
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
        title: const Text('Create Project'),
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
              BlocBuilder<ClientBloc, ClientState>(
                builder: (context, state) {
                  return TypeAheadFormField<Client>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _clientIDController,
                      decoration: const InputDecoration(labelText: 'Client'),
                    ),
                    suggestionsCallback: (pattern) async {
                      context.read<ClientBloc>().add(SearchClients(
                            searchTerm: pattern,
                            pageNumber: 1,
                            pageSize: 10,
                          ));
                      if (state is ClientLoaded) {
                        return state.clients;
                      }
                      return [];
                    },
                    itemBuilder: (context, Client suggestion) {
                      return ListTile(
                        title: Text(suggestion.firstName),
                      );
                    },
                    onSuggestionSelected: (Client suggestion) {
                      _clientIDController.text = suggestion.firstName;
                      _selectedClientID = suggestion.clientID;
                    },
                    noItemsFoundBuilder: (context) =>
                        const Text('No clients found'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please select a client'
                        : null,
                  );
                },
              ),
              BlocBuilder<LawyerBloc, LawyerState>(
                builder: (context, state) {
                  return TypeAheadFormField<Lawyer>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _lawyerIDController,
                      decoration: const InputDecoration(labelText: 'Lawyer'),
                    ),
                    suggestionsCallback: (pattern) async {
                      context.read<LawyerBloc>().add(SearchLawyers(
                            searchTerm: pattern,
                            pageNumber: 1,
                            pageSize: 10,
                          ));
                      if (state is LawyerLoaded) {
                        return state.lawyers;
                      }
                      return [];
                    },
                    itemBuilder: (context, Lawyer suggestion) {
                      return ListTile(
                        title: Text(suggestion.firstName),
                      );
                    },
                    onSuggestionSelected: (Lawyer suggestion) {
                      _lawyerIDController.text = suggestion.firstName;
                      _selectedLawyerID = suggestion.lawyerID;
                    },
                    noItemsFoundBuilder: (context) =>
                        const Text('No lawyers found'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please select a lawyer'
                        : null,
                  );
                },
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
