import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/project_repository.dart';
import 'project_event.dart';
import 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository projectRepository;

  ProjectBloc({required this.projectRepository}) : super(ProjectInitial()) {
    on<FetchProjects>(_onFetchProjects);
    on<SearchProjects>(_onSearchProjects);
    on<AddProject>(_onAddProject);
    on<UpdateProject>(_onUpdateProject);
    on<DeleteProject>(_onDeleteProject);
  }

  Future<void> _onFetchProjects(
    FetchProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      final response = await projectRepository.fetchProjects(
          event.pageNumber, event.pageSize);
      emit(ProjectLoaded(
        projects: response.projects,
        totalCount: response.totalCount,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(ProjectError(message: e.toString()));
    }
  }

  Future<void> _onSearchProjects(
    SearchProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      if (event.searchTerm.trim().length < 2) {
        emit(ProjectInitial());
        return;
      }
      final response = await projectRepository.searchProjects(
        event.searchTerm,
        event.pageNumber,
        event.pageSize,
      );
      emit(ProjectLoaded(
        projects: response.projects,
        totalCount: response.totalCount,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(ProjectError(message: e.toString()));
    }
  }

  Future<void> _onAddProject(
    AddProject event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      final project = await projectRepository.addProject(event.project);
      emit(ProjectAdded(project: project));
      add(FetchProjects(
          pageNumber: 1, pageSize: 10)); // Refresh list after adding
    } catch (e) {
      emit(ProjectError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProject(
    UpdateProject event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      await projectRepository.updateProject(
          event.project.projectID!, event.project);
      emit(ProjectUpdated(project: event.project));
      add(FetchProjects(
          pageNumber: 1, pageSize: 10)); // Refresh list after updating
    } catch (e) {
      emit(ProjectError(message: e.toString()));
    }
  }

  Future<void> _onDeleteProject(
    DeleteProject event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      await projectRepository.deleteProject(event.projectID);
      emit(ProjectDeleted(projectID: event.projectID));
      add(FetchProjects(
          pageNumber: 1, pageSize: 10)); // Refresh list after deleting
    } catch (e) {
      emit(ProjectError(message: e.toString()));
    }
  }
}
