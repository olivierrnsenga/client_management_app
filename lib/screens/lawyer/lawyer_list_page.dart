import 'package:client_management_app/blocs/lawyer/lawyer_bloc.dart';
import 'package:client_management_app/blocs/lawyer/lawyer_event.dart';
import 'package:client_management_app/blocs/lawyer/lawyer_state.dart';
import 'package:client_management_app/models/lawyer/lawyer.dart';
import 'package:client_management_app/repositories/lawyer_repository.dart';
import 'package:client_management_app/screens/lawyer/create_lawyer_page.dart';
import 'package:client_management_app/widgets/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_lawyer_page.dart'; // Import the edit screen

class LawyerListPage extends StatefulWidget {
  const LawyerListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LawyerListPageState createState() => _LawyerListPageState();
}

class _LawyerListPageState extends State<LawyerListPage> {
  late LawyerBloc _lawyerBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final lawyerRepository =
        LawyerRepository(baseUrl: 'https://localhost:7137/api');
    _lawyerBloc = LawyerBloc(lawyerRepository: lawyerRepository);
    _lawyerBloc.add(FetchLawyers(pageNumber: 1, pageSize: 10));

    _searchController.addListener(() {
      final searchTerm = _searchController.text;
      _lawyerBloc.add(SearchLawyers(
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
        title: const Text('Lawyers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addLawyer,
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
                hintText: 'Search lawyers',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<LawyerBloc, LawyerState>(
        bloc: _lawyerBloc,
        builder: (context, state) {
          if (state is LawyerInitial) {
            return const Center(child: Text('Please wait...'));
          } else if (state is LawyerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LawyerLoaded) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('First Name')),
                        DataColumn(label: Text('Last Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Specialization')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: state.lawyers.map((lawyer) {
                        return DataRow(
                          cells: [
                            DataCell(Text(lawyer.firstName)),
                            DataCell(Text(lawyer.lastName)),
                            DataCell(Text(lawyer.email)),
                            DataCell(Text(lawyer.phone)),
                            DataCell(Text(lawyer.specialization)),
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _updateLawyer(lawyer),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteLawyer(lawyer),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (String value) {
                                      switch (value) {
                                        case 'Email':
                                          // Implement emailing functionality
                                          break;
                                        case 'Phone':
                                          // Implement phone functionality
                                          break;
                                        default:
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Email',
                                        child: Text('Email'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'Phone',
                                        child: Text('Phone'),
                                      ),
                                    ],
                                    icon: const Icon(Icons.more_vert),
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
                    _lawyerBloc.add(
                        FetchLawyers(pageNumber: pageNumber, pageSize: 10));
                  },
                ),
              ],
            );
          } else if (state is LawyerError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }

  void _addLawyer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const CreateLawyerPage(), // Removed the 'lawyer' parameter
      ),
    );
  }

  void _updateLawyer(Lawyer lawyer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLawyerPage(lawyer: lawyer),
      ),
    );
  }

  void _deleteLawyer(Lawyer lawyer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete ${lawyer.firstName} ${lawyer.lastName}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _lawyerBloc.add(DeleteLawyer(lawyerID: lawyer.lawyerID));
              },
            ),
          ],
        );
      },
    );
  }
}
