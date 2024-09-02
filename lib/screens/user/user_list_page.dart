import 'package:client_management_app/blocs/user/user_bloc.dart';
import 'package:client_management_app/blocs/user/user_event.dart';
import 'package:client_management_app/blocs/user/user_state.dart';
import 'package:client_management_app/models/user/user.dart';
import 'package:client_management_app/repositories/user_repository.dart';
import 'package:client_management_app/screens/user/create_user_page.dart';
import 'package:client_management_app/screens/user/edit_user_page.dart';
import 'package:client_management_app/widgets/pagination_controls.dart'; // Import pagination controls
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late UserBloc _userBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userRepository =
        UserRepository(baseUrl: 'https://localhost:7137/api');
    _userBloc = UserBloc(userRepository: userRepository);
    _userBloc.add(const FetchUsers(pageNumber: 1, pageSize: 10));

    _searchController.addListener(() {
      final searchTerm = _searchController.text;
      _userBloc.add(SearchUsers(
        searchTerm: searchTerm,
        pageNumber: 1,
        pageSize: 10,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addUser,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search users',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        bloc: _userBloc,
        builder: (context, state) {
          if (state is UserInitial) {
            return const Center(child: Text('Please wait...'));
          } else if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Username')),
                          DataColumn(label: Text('Role')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: state.users.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(Text(user.username)),
                              DataCell(Text(user.role)),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _updateUser(user),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _deleteUser(user),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (String value) {
                                        switch (value) {
                                          case 'Email':
                                            // Implement emailing functionality
                                            break;
                                          case 'Phone':
                                            // Implement phone functionality
                                            break;
                                          default:
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'Email',
                                          child: Text('Email'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'Phone',
                                          child: Text('Phone'),
                                        ),
                                      ],
                                      icon: const Icon(Icons.more_vert),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                PaginationControls(
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                  totalCount: state.totalCount,
                  onPageChanged: (pageNumber) {
                    _userBloc
                        .add(FetchUsers(pageNumber: pageNumber, pageSize: 10));
                  },
                ),
              ],
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }

  void _addUser() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateUserPage(),
      ),
    );
  }

  void _updateUser(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserPage(user: user),
      ),
    );
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${user.username}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _userBloc.add(DeleteUser(userID: user.userID));
              },
            ),
          ],
        );
      },
    );
  }
}
