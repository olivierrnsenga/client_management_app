import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/client/client_bloc.dart';
import 'blocs/lawyer/lawyer_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'repositories/client_repository.dart';
import 'repositories/lawyer_repository.dart';
import 'repositories/user_repository.dart';
import 'screens/home_page.dart';
import 'screens/login/login_user.dart';

void main() {
  runApp(const MyApp());
}

class AppConfig {
  final String baseUrl;

  AppConfig({required this.baseUrl});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AppConfig(baseUrl: 'https://localhost:7137/api'),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ClientRepository>(
            create: (context) {
              final config = RepositoryProvider.of<AppConfig>(context);
              return ClientRepository(baseUrl: config.baseUrl);
            },
          ),
          RepositoryProvider<LawyerRepository>(
            create: (context) {
              final config = RepositoryProvider.of<AppConfig>(context);
              return LawyerRepository(baseUrl: config.baseUrl);
            },
          ),
          RepositoryProvider<UserRepository>(
            create: (context) {
              final config = RepositoryProvider.of<AppConfig>(context);
              return UserRepository(baseUrl: config.baseUrl);
            },
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ClientBloc>(
              create: (context) => ClientBloc(
                clientRepository:
                    RepositoryProvider.of<ClientRepository>(context),
              ),
            ),
            BlocProvider<LawyerBloc>(
              create: (context) => LawyerBloc(
                lawyerRepository:
                    RepositoryProvider.of<LawyerRepository>(context),
              ),
            ),
            BlocProvider<UserBloc>(
              create: (context) => UserBloc(
                userRepository: RepositoryProvider.of<UserRepository>(context),
              ),
            ),
          ],
          child: MaterialApp(
            title: 'Client Management',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const LoginPageWrapper(), // Wrapped LoginPage
            routes: {
              '/home': (context) => const HomePage(),
            },
          ),
        ),
      ),
    );
  }
}

class LoginPageWrapper extends StatelessWidget {
  const LoginPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = RepositoryProvider.of<UserRepository>(context);
    return LoginPage(userRepository: userRepository);
  }
}
