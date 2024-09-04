import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_management_app/blocs/document/document_bloc.dart';
import 'package:client_management_app/blocs/document/document_event.dart';
import 'package:client_management_app/blocs/document/document_state.dart';
import 'package:client_management_app/models/document/document.dart';
import 'package:client_management_app/widgets/pagination_controls.dart';
import 'package:client_management_app/repositories/document_repository.dart';

class DocumentListPage extends StatefulWidget {
  const DocumentListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DocumentListPageState createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  late DocumentBloc _documentBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final documentRepository =
        DocumentRepository(baseUrl: 'https://localhost:7137/api');
    _documentBloc = DocumentBloc(documentRepository: documentRepository);
    _documentBloc.add(const FetchAllDocuments(
        pageNumber: 1, pageSize: 10)); // Fetch all documents initially

    _searchController.addListener(() {
      final searchTerm = _searchController.text;
      _documentBloc.add(SearchDocuments(
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
        title: const Text('Documents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addDocument,
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
                hintText: 'Search documents',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<DocumentBloc, DocumentState>(
        bloc: _documentBloc,
        builder: (context, state) {
          if (state is DocumentInitial) {
            return const Center(child: Text('Please wait...'));
          } else if (state is DocumentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DocumentLoaded) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Document Name')),
                        DataColumn(label: Text('Document Type')),
                        DataColumn(label: Text('Upload Date')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: state.documents.map((document) {
                        return DataRow(
                          cells: [
                            DataCell(Text(document.documentName)),
                            DataCell(Text(document.documentType)),
                            DataCell(Text(document.uploadDate.toString())),
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _updateDocument(document),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteDocument(document),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (String value) {
                                      switch (value) {
                                        case 'Preview':
                                          _previewDocument(document);
                                          break;
                                        case 'Download':
                                          _downloadDocument(document);
                                          break;
                                        default:
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Preview',
                                        child: Text('Preview'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'Download',
                                        child: Text('Download'),
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
                PaginationControls(
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                  totalCount: state.totalCount,
                  onPageChanged: (pageNumber) {
                    _documentBloc.add(FetchAllDocuments(
                        pageNumber: pageNumber,
                        pageSize: 10)); // Fetch all documents on page change
                  },
                ),
              ],
            );
          } else if (state is DocumentError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }

  void _addDocument() {
    // Implement document addition logic here
  }

  void _updateDocument(Document document) {
    // Implement document update logic here
  }

  void _deleteDocument(Document document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              Text('Are you sure you want to delete ${document.documentName}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _documentBloc.add(DeleteDocument(
                    documentID: document.documentID!,
                    projectId: document.projectID));
              },
            ),
          ],
        );
      },
    );
  }

  void _previewDocument(Document document) {
    // Implement preview functionality
  }

  void _downloadDocument(Document document) {
    // Implement download functionality
  }
}
