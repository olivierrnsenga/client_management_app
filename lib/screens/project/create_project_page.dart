import 'package:client_management_app/models/project/project_client.dart';
import 'package:client_management_app/models/project/project_lawyer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late TextEditingController _clientSearchController;
  late TextEditingController _lawyerSearchController;
  final List<Client> _selectedClients = [];
  final List<Lawyer> _selectedLawyers = [];

  @override
  void initState() {
    super.initState();
    _projectNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _clientSearchController = TextEditingController();
    _lawyerSearchController = TextEditingController();
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _clientSearchController.dispose();
    _lawyerSearchController.dispose();
    super.dispose();
  }

  void _saveProject() {
    if (_formKey.currentState?.validate() ?? false) {
      final newProject = Project(
        projectName: _projectNameController.text,
        description: _descriptionController.text,
        startDate: DateTime.parse(_startDateController.text),
        endDate: DateTime.parse(_endDateController.text),
        projectClients: _selectedClients
            .map((client) => ProjectClient(
                  projectID:
                      0, // Use 0 or a temporary ID if creating a new project
                  clientID: client.clientID,
                  client: client,
                ))
            .toList(),
        projectLawyers: _selectedLawyers
            .map((lawyer) => ProjectLawyer(
                  projectID:
                      0, // Use 0 or a temporary ID if creating a new project
                  lawyerID: lawyer.lawyerID,
                  lawyer: lawyer,
                ))
            .toList(),
        statusID: 1, // Example status ID, adjust as needed
      );
      context.read<ProjectBloc>().add(AddProject(project: newProject));
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
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                children: _selectedClients.map((client) {
                  return Chip(
                    label: Text('${client.firstName} ${client.lastName}'),
                    onDeleted: () {
                      setState(() {
                        _selectedClients.remove(client);
                      });
                    },
                  );
                }).toList(),
              ),
              TypeAheadFormField<Client>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _clientSearchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Client',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  context.read<ClientBloc>().add(SearchClients(
                        searchTerm: pattern,
                        pageNumber: 1,
                        pageSize: 10,
                      ));
                  if (context.read<ClientBloc>().state is ClientLoaded) {
                    return (context.read<ClientBloc>().state as ClientLoaded)
                        .clients;
                  }
                  return [];
                },
                itemBuilder: (context, Client suggestion) {
                  return ListTile(
                    title:
                        Text('${suggestion.firstName} ${suggestion.lastName}'),
                  );
                },
                onSuggestionSelected: (Client selectedClient) {
                  setState(() {
                    _selectedClients.add(selectedClient);
                    _clientSearchController.clear();
                  });
                },
                noItemsFoundBuilder: (context) =>
                    const Text('No clients found'),
              ),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                children: _selectedLawyers.map((lawyer) {
                  return Chip(
                    label: Text('${lawyer.firstName} ${lawyer.lastName}'),
                    onDeleted: () {
                      setState(() {
                        _selectedLawyers.remove(lawyer);
                      });
                    },
                  );
                }).toList(),
              ),
              TypeAheadFormField<Lawyer>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _lawyerSearchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Lawyer',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  context.read<LawyerBloc>().add(SearchLawyers(
                        searchTerm: pattern,
                        pageNumber: 1,
                        pageSize: 10,
                      ));
                  if (context.read<LawyerBloc>().state is LawyerLoaded) {
                    return (context.read<LawyerBloc>().state as LawyerLoaded)
                        .lawyers;
                  }
                  return [];
                },
                itemBuilder: (context, Lawyer suggestion) {
                  return ListTile(
                    title:
                        Text('${suggestion.firstName} ${suggestion.lastName}'),
                  );
                },
                onSuggestionSelected: (Lawyer selectedLawyer) {
                  setState(() {
                    _selectedLawyers.add(selectedLawyer);
                    _lawyerSearchController.clear();
                  });
                },
                noItemsFoundBuilder: (context) =>
                    const Text('No lawyers found'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _startDateController,
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
