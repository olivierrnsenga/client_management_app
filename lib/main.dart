import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/client/client_bloc.dart';
import 'blocs/lawyer/lawyer_bloc.dart'; // Import LawyerBloc
import 'repositories/client_repository.dart';
import 'repositories/lawyer_repository.dart'; // Import LawyerRepository
import 'screens/home_page.dart'; // New HomePage with the sidebar

void main() {
  final clientRepository =
      ClientRepository(baseUrl: 'https://localhost:7137/api');
  final lawyerRepository = LawyerRepository(
      baseUrl: 'https://localhost:7137/api'); // Initialize LawyerRepository

  runApp(MyApp(
      clientRepository: clientRepository, lawyerRepository: lawyerRepository));
}

class MyApp extends StatelessWidget {
  final ClientRepository clientRepository;
  final LawyerRepository lawyerRepository; // Add LawyerRepository

  const MyApp(
      {super.key,
      required this.clientRepository,
      required this.lawyerRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClientBloc>(
          create: (context) => ClientBloc(clientRepository: clientRepository),
        ),
        BlocProvider<LawyerBloc>(
          create: (context) => LawyerBloc(lawyerRepository: lawyerRepository),
        ),
      ],
      child: const MaterialApp(
        title: 'Client Management',
        home: HomePage(), // HomePage will contain the header and sidebar
      ),
    );
  }
}
