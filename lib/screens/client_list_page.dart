import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/client/client_bloc.dart';
import '../blocs/client/client_event.dart';
import '../blocs/client/client_state.dart';
import '../repositories/client_repository.dart';
import '../widgets/pagination_controls.dart';

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
        pageNumber: 1, // Starting at page 1 for search
        pageSize: 10,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
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
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('City')),
                        DataColumn(label: Text('State')),
                        DataColumn(label: Text('Date of Birth')),
                      ],
                      rows: state.clients.map((client) {
                        return DataRow(
                          cells: [
                            DataCell(Text(client.firstName)),
                            DataCell(Text(client.lastName)),
                            DataCell(Text(client.email)),
                            DataCell(Text(client.phone)),
                            DataCell(Text(
                                '${client.address}, ${client.city}, ${client.state}, ${client.zipCode}')),
                            DataCell(Text(client.city)),
                            DataCell(Text(client.state)),
                            DataCell(Text(client.dateOfBirth)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PaginationControls(
                    currentPage: state.currentPage,
                    totalPages: state.totalPages,
                    totalCount: state.totalCount,
                    onPageChanged: (page) {
                      _clientBloc
                          .add(FetchClients(pageNumber: page, pageSize: 10));
                    },
                  ),
                ),
              ],
            );
          } else if (state is ClientError) {
            return Center(child: Text(state.message));
          } else {
            return Container();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _clientBloc.close();
    _searchController.dispose();
    super.dispose();
  }
}
