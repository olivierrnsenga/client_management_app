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

  @override
  void initState() {
    super.initState();
    final clientRepository =
        ClientRepository(baseUrl: 'https://localhost:7137/api');
    _clientBloc = ClientBloc(clientRepository: clientRepository);
    _clientBloc.add(FetchClients(pageNumber: 1, pageSize: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Clients: ${state.totalCount}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.clients.length,
                    itemBuilder: (context, index) {
                      final client = state.clients[index];
                      return ListTile(
                        title: Text('${client.firstName} ${client.lastName}'),
                        subtitle: Text(client.email),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PaginationControls(
                    currentPage: state.currentPage,
                    totalPages: state.totalPages,
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
    super.dispose();
  }
}
