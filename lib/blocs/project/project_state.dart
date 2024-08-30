import 'package:client_management_app/models/project/project.dart';
import 'package:equatable/equatable.dart';

abstract class ProjectState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<Project> projects;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  ProjectLoaded({
    required this.projects,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [projects, totalCount, currentPage, totalPages];
}

class ProjectAdded extends ProjectState {
  final Project project;

  ProjectAdded({required this.project});

  @override
  List<Object?> get props => [project];
}

class ProjectUpdated extends ProjectState {
  final Project project;

  ProjectUpdated({required this.project});

  @override
  List<Object?> get props => [project];
}

class ProjectDeleted extends ProjectState {
  final int projectID;

  ProjectDeleted({required this.projectID});

  @override
  List<Object?> get props => [projectID];
}

class ProjectError extends ProjectState {
  final String message;

  ProjectError({required this.message});

  @override
  List<Object?> get props => [message];
}
