import 'package:client_management_app/blocs/client/client_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/client/client_bloc.dart';
import '../models/client.dart';

class CreateClientPage extends StatefulWidget {
  const CreateClientPage({super.key, client});

  @override
  // ignore: library_private_types_in_public_api
  _CreateClientPageState createState() => _CreateClientPageState();
}

class _CreateClientPageState extends State<CreateClientPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _dateOfBirthController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
    _dateOfBirthController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _saveClient() {
    if (_formKey.currentState?.validate() ?? false) {
      final newClient = Client(
        clientID: 0, // Assuming the server will assign the ID
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        zipCode: _zipCodeController.text,
        dateOfBirth: _dateOfBirthController.text,
      );
      context.read<ClientBloc>().add(AddClient(client: newClient));
      Navigator.pop(context); // Go back to the client list page after saving
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dateOfBirthController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Client'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveClient,
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
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter address' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter city' : null,
              ),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter state' : null,
              ),
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(labelText: 'Zip Code'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter zip code' : null,
              ),
              TextFormField(
                controller: _dateOfBirthController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please select date of birth'
                    : null,
                onTap: () =>
                    _selectDate(context), // This makes the whole field tappable
              ),
            ],
          ),
        ),
      ),
    );
  }
}
