import 'package:client_management_app/blocs/project/project_bloc.dart';
import 'package:client_management_app/blocs/project/project_event.dart';
import 'package:client_management_app/blocs/project/project_state.dart';
import 'package:client_management_app/models/project/project.dart';
import 'package:client_management_app/repositories/project_repository.dart';
import 'package:client_management_app/screens/project/create_project_page.dart';
import 'package:client_management_app/screens/project/edit_project_page.dart';
import 'package:client_management_app/screens/project/project_details_page.dart';
import 'package:client_management_app/widgets/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  late ProjectBloc _projectBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final projectRepository = RepositoryProvider.of<ProjectRepository>(context);
    _projectBloc = ProjectBloc(projectRepository: projectRepository);
    _projectBloc.add(FetchProjects(pageNumber: 1, pageSize: 10));

    _searchController.addListener(() {
      final searchTerm = _searchController.text;
      _projectBloc.add(SearchProjects(
        searchTerm: searchTerm,
        pageNumber: 1,
        pageSize: 10,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addProject,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search projects',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProjectBloc, ProjectState>(
        bloc: _projectBloc,
        builder: (context, state) {
          if (state is ProjectInitial) {
            return const Center(child: Text('Please wait...'));
          } else if (state is ProjectLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProjectLoaded) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Project Name')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Start Date')),
                        DataColumn(label: Text('End Date')),
                        DataColumn(label: Text('Clients')),
                        DataColumn(label: Text('Lawyers')),
                        DataColumn(label: Text('Status ID')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: state.projects.map((project) {
                        return DataRow(
                          cells: [
                            DataCell(
                              GestureDetector(
                                onTap: () => _showProjectDetails(project),
                                child: Text(project.projectName),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => _showProjectDetails(project),
                                child: Text(project.description),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => _showProjectDetails(project),
                                child: Text(project.startDate.toString()),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => _showProjectDetails(project),
                                child: Text(project.endDate.toString()),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => _showProjectDetails(project),
                                child: Text(
                                  project.projectClients
                                      .map((pc) =>
                                          '${pc.client.firstName} ${pc.client.lastName}')
                                      .join(', '),
                                ),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => _showProjectDetails(project),
                                child: Text(
                                  project.projectLawyers
                                      .map((pl) =>
                                          '${pl.lawyer.firstName} ${pl.lawyer.lastName}')
                                      .join(', '),
                                ),
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => _showProjectDetails(project),
                                child: Text(project.statusID.toString()),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () =>
                                        _showProjectDetails(project),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _updateProject(project),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteProject(project),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                PaginationControls(
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                  totalCount: state.totalCount,
                  onPageChanged: (pageNumber) {
                    _projectBloc.add(
                        FetchProjects(pageNumber: pageNumber, pageSize: 10));
                  },
                ),
              ],
            );
          } else if (state is ProjectError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }

  void _addProject() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ProjectBloc>.value(
          value: _projectBloc,
          child: const CreateProjectPage(),
        ),
      ),
    );
  }

  void _updateProject(Project project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ProjectBloc>.value(
          value: _projectBloc,
          child: EditProjectPage(project: project),
        ),
      ),
    );
  }

  void _deleteProject(Project project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              Text('Are you sure you want to delete ${project.projectName}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _projectBloc.add(DeleteProject(projectID: project.projectID!));
              },
            ),
          ],
        );
      },
    );
  }

  void _showProjectDetails(Project project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ProjectBloc>.value(
          value: _projectBloc,
          child: ProjectDetailsPage(project: project),
        ),
      ),
    );
  }
}
