import 'package:client_management_app/blocs/user/user_bloc.dart';
import 'package:client_management_app/blocs/user/user_event.dart';
import 'package:client_management_app/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _roleController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _saveUser() {
    if (_formKey.currentState?.validate() ?? false) {
      final newUser = User(
        userID: 0, // Assuming server assigns the ID
        username: _usernameController.text,
        password: _passwordController.text,
        role: _roleController.text,
      );
      context
          .read<UserBloc>()
          .add(AddUser(user: newUser)); // Make sure this is recognized
      Navigator.pop(context); // Go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveUser,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter username' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter password' : null,
              ),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Role'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter role' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
