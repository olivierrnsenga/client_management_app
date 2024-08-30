import 'package:client_management_app/models/project/project.dart';
import 'package:equatable/equatable.dart';

abstract class ProjectEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchProjects extends ProjectEvent {
  final int pageNumber;
  final int pageSize;

  FetchProjects({required this.pageNumber, required this.pageSize});

  @override
  List<Object> get props => [pageNumber, pageSize];
}

class SearchProjects extends ProjectEvent {
  final String searchTerm;
  final int pageNumber;
  final int pageSize;

  SearchProjects(
      {required this.searchTerm,
      required this.pageNumber,
      required this.pageSize});

  @override
  List<Object> get props => [searchTerm, pageNumber, pageSize];
}

class AddProject extends ProjectEvent {
  final Project project;

  AddProject({required this.project});

  @override
  List<Object> get props => [project];
}

class UpdateProject extends ProjectEvent {
  final Project project;

  UpdateProject({required this.project});

  @override
  List<Object> get props => [project];
}

class DeleteProject extends ProjectEvent {
  final int projectID;

  DeleteProject({required this.projectID});

  @override
  List<Object> get props => [projectID];
}
