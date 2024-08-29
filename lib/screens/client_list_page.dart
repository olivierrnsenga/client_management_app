import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/client/client_bloc.dart';
import '../blocs/client/client_event.dart';
import '../blocs/client/client_state.dart';
import '../repositories/client_repository.dart';
import '../widgets/pagination_controls.dart';
import '../models/client.dart';
import 'edit_client_page.dart'; // Import the new edit screen

class ClientListPage extends StatefulWidget {
  const ClientListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClientListPageState createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  late ClientBloc _clientBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final clientRepository =
        ClientRepository(baseUrl: 'https://localhost:7137/api');
    _clientBloc = ClientBloc(clientRepository: clientRepository);
    _clientBloc.add(FetchClients(pageNumber: 1, pageSize: 10));

    _searchController.addListener(() {
      final searchTerm = _searchController.text;
      _clientBloc.add(SearchClients(
        searchTerm: searchTerm,
        pageNumber: 1,
        pageSize: 10,
      ));
    });
  }

  void _addClient() {
    final newClient = Client(
      clientID: 0,
      firstName: 'New',
      lastName: 'Client',
      email: 'new.client@example.com',
      phone: '1234567890',
      address: '123 New Street',
      city: 'New City',
      state: 'NC',
      zipCode: '12345',
      dateOfBirth: '2000-01-01',
    );
    _clientBloc.add(AddClient(client: newClient));
  }

  void _updateClient(Client client) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditClientPage(client: client),
      ),
    );
  }

  void _deleteClient(Client client) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete ${client.firstName} ${client.lastName}?',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _clientBloc.add(DeleteClient(clientID: client.clientID));
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addClient,
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
                hintText: 'Search clients',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ClientBloc, ClientState>(
        bloc: _clientBloc,
        builder: (context, state) {
          if (state is ClientInitial) {
            return const Center(child: Text('Please wait...'));
          } else if (state is ClientLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ClientLoaded) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('City')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: state.clients.map((client) {
                  return DataRow(
                    cells: [
                      DataCell(Text(client.firstName)),
                      DataCell(Text(client.lastName)),
                      DataCell(Text(client.email)),
                      DataCell(Text(client.phone)),
                      DataCell(Text(client.city)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _updateClient(client),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteClient(client),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          } else if (state is ClientError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<ClientBloc, ClientState>(
        bloc: _clientBloc,
        builder: (context, state) {
          if (state is ClientLoaded) {
            return PaginationControls(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              totalCount: state.totalCount,
              onPageChanged: (pageNumber) {
                _clientBloc
                    .add(FetchClients(pageNumber: pageNumber, pageSize: 10));
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
