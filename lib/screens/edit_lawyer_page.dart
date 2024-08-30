import 'package:client_management_app/blocs/client/lawyer/lawyer.dart';
import 'package:client_management_app/blocs/client/lawyer/lawyer_bloc.dart';
import 'package:client_management_app/blocs/client/lawyer/lawyer_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditLawyerPage extends StatefulWidget {
  final Lawyer lawyer;

  const EditLawyerPage({super.key, required this.lawyer});

  @override
  // ignore: library_private_types_in_public_api
  _EditLawyerPageState createState() => _EditLawyerPageState();
}

class _EditLawyerPageState extends State<EditLawyerPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _specializationController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.lawyer.firstName);
    _lastNameController = TextEditingController(text: widget.lawyer.lastName);
    _emailController = TextEditingController(text: widget.lawyer.email);
    _phoneController = TextEditingController(text: widget.lawyer.phone);
    _specializationController =
        TextEditingController(text: widget.lawyer.specialization);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  void _saveLawyer() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedLawyer = widget.lawyer.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        specialization: _specializationController.text,
      );
      context.read<LawyerBloc>().add(UpdateLawyer(lawyer: updatedLawyer));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Lawyer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveLawyer,
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
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter first name' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter last name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter email' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter phone number' : null,
              ),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(labelText: 'Specialization'),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter specialization'
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
