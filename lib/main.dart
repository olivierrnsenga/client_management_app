import 'package:client_management_app/blocs/user/user_bloc.dart';
import 'package:client_management_app/repositories/user_repository.dart';
import 'package:client_management_app/screens/login/login_user.dart'; // Adjust this import path if necessary
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/client/client_bloc.dart';
import 'blocs/lawyer/lawyer_bloc.dart';
import 'repositories/client_repository.dart';
import 'repositories/lawyer_repository.dart';
import 'screens/home_page.dart';

void main() {
  final clientRepository =
      ClientRepository(baseUrl: 'https://localhost:7137/api');
  final lawyerRepository =
      LawyerRepository(baseUrl: 'https://localhost:7137/api');
  final userRepository = UserRepository(baseUrl: 'https://localhost:7137/api');

  runApp(MyApp(
    clientRepository: clientRepository,
    lawyerRepository: lawyerRepository,
    userRepository: userRepository,
  ));
}

class MyApp extends StatelessWidget {
  final ClientRepository clientRepository;
  final LawyerRepository lawyerRepository;
  final UserRepository userRepository;

  const MyApp({
    super.key,
    required this.clientRepository,
    required this.lawyerRepository,
    required this.userRepository,
  });

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
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: userRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Client Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(userRepository: userRepository), // Start with LoginPage
        routes: {
          '/home': (context) =>
              const HomePage(), // Define a route for the home page
        },
      ),
    );
  }
}
