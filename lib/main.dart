import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/client/client_bloc.dart'; // Adjust import based on your project structure
import 'repositories/client_repository.dart'; // Adjust import based on your project structure
import 'screens/client_list_page.dart';

void main() {
  final clientRepository = ClientRepository(
      baseUrl:
          'https://localhost:7137/api'); // Create an instance of ClientRepository

  runApp(MyApp(clientRepository: clientRepository));
}

class MyApp extends StatelessWidget {
  final ClientRepository clientRepository;

  const MyApp({super.key, required this.clientRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientBloc(
          clientRepository: clientRepository), // Provide ClientBloc here
      child: const MaterialApp(
        title: 'Client Management',
        home: ClientListPage(),
      ),
    );
  }
}
