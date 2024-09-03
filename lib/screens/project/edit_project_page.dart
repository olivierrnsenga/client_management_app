import 'package:client_management_app/models/status/status.dart';
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
import 'package:client_management_app/blocs/status/status_bloc.dart';
import 'package:client_management_app/blocs/status/status_event.dart';
import 'package:client_management_app/blocs/status/status_state.dart';
import 'package:client_management_app/models/client/client.dart';
import 'package:client_management_app/models/lawyer/lawyer.dart';
import 'package:client_management_app/models/project/project.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
  late TextEditingController _clientSearchController;
  late TextEditingController _lawyerSearchController;

  final List<ProjectClient> _selectedProjectClients = [];
  final List<ProjectLawyer> _selectedProjectLawyers = [];
  Status? _selectedStatus;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the current project data
    _projectNameController =
        TextEditingController(text: widget.project.projectName);
    _descriptionController =
        TextEditingController(text: widget.project.description);
    _startDateController =
        TextEditingController(text: widget.project.startDate.toIso8601String());
    _endDateController =
        TextEditingController(text: widget.project.endDate.toIso8601String());
    _clientSearchController = TextEditingController();
    _lawyerSearchController = TextEditingController();

    // Initialize selected clients, lawyers, and status
    _selectedProjectClients.addAll(widget.project.projectClients);
    _selectedProjectLawyers.addAll(widget.project.projectLawyers);
    _selectedStatus = widget.project.status;

    // Fetch statuses when the page is initialized
    context.read<StatusBloc>().add(FetchStatuses());
  }

  @override
  void dispose() {
    // Dispose of all controllers
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
      final updatedProject = widget.project.copyWith(
        projectName: _projectNameController.text,
        description: _descriptionController.text,
        startDate: DateTime.parse(_startDateController.text),
        endDate: DateTime.parse(_endDateController.text),
        projectClients: _selectedProjectClients,
        projectLawyers: _selectedProjectLawyers,
        status: _selectedStatus!, // Ensure that a status is selected
      );
      context.read<ProjectBloc>().add(UpdateProject(project: updatedProject));
      Navigator.pop(context);
    }
  }

  Status _getExactStatusMatch(Status? selectedStatus, List<Status> statuses) {
    if (selectedStatus == null || statuses.isEmpty) {
      return statuses.first; // Provide a default Status when no match is found
    }

    return statuses.firstWhere(
      (status) => status.statusID == selectedStatus.statusID,
      orElse: () =>
          statuses.first, // Return the first status if no match is found
    );
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
                    avatar: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    label: Text(
                        '${projectClient.client.firstName} ${projectClient.client.lastName}'),
                    onDeleted: () {
                      setState(() {
                        _selectedProjectClients.remove(projectClient);
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
                    _selectedProjectClients.add(
                      ProjectClient(
                        projectID: widget.project.projectID!,
                        clientID: selectedClient.clientID,
                        client: selectedClient,
                      ),
                    );
                    _clientSearchController.clear();
                  });
                },
                noItemsFoundBuilder: (context) =>
                    const Text('No clients found'),
              ),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                children: _selectedProjectLawyers.map((projectLawyer) {
                  return Chip(
                    avatar: const CircleAvatar(
                      child: Icon(Icons.person_outline),
                    ),
                    label: Text(
                        '${projectLawyer.lawyer.firstName} ${projectLawyer.lawyer.lastName}'),
                    onDeleted: () {
                      setState(() {
                        _selectedProjectLawyers.remove(projectLawyer);
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
                    _selectedProjectLawyers.add(
                      ProjectLawyer(
                        projectID: widget.project.projectID!,
                        lawyerID: selectedLawyer.lawyerID,
                        lawyer: selectedLawyer,
                      ),
                    );
                    _lawyerSearchController.clear();
                  });
                },
                noItemsFoundBuilder: (context) =>
                    const Text('No lawyers found'),
              ),
              const SizedBox(height: 16.0),
              BlocBuilder<StatusBloc, StatusState>(
                builder: (context, state) {
                  if (state is StatusLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is StatusLoaded) {
                    // Match selected status with exact instance from list
                    _selectedStatus =
                        _getExactStatusMatch(_selectedStatus, state.statuses);

                    return DropdownButtonFormField<Status>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: state.statuses.map((status) {
                        return DropdownMenuItem<Status>(
                          value: status,
                          child: Text(status.statusName),
                        );
                      }).toList(),
                      onChanged: (Status? newValue) {
                        setState(() {
                          _selectedStatus = newValue!;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a status' : null,
                    );
                  } else if (state is StatusError) {
                    return Text('Error: ${state.message}');
                  } else {
                    return const SizedBox();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
