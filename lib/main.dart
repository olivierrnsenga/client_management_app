import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/client/client_bloc.dart';
import 'repositories/client_repository.dart';
import 'screens/home_page.dart'; // New HomePage with the sidebar

void main() {
  final clientRepository =
      ClientRepository(baseUrl: 'https://localhost:7137/api');

  runApp(MyApp(clientRepository: clientRepository));
}

class MyApp extends StatelessWidget {
  final ClientRepository clientRepository;

  const MyApp({super.key, required this.clientRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientBloc(clientRepository: clientRepository),
      child: const MaterialApp(
        title: 'Client Management',
        home: HomePage(), // HomePage will contain the header and sidebar
      ),
    );
  }
}
