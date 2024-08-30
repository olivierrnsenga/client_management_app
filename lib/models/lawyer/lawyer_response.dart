import 'dart:convert';

import 'package:client_management_app/models/lawyer/lawyer.dart';

class LawyerResponse {
  final List<Lawyer> lawyers;
  final int totalCount;
  final int pageSize;
  final int currentPage;
  final int totalPages;

  LawyerResponse({
    required this.lawyers,
    required this.totalCount,
    required this.pageSize,
    required this.currentPage,
    required this.totalPages,
  });

  factory LawyerResponse.fromJson(
      Map<String, dynamic> json, String paginationJson) {
    var lawyerList = json['lawyers'] as List;
    List<Lawyer> lawyers = lawyerList.map((i) => Lawyer.fromJson(i)).toList();

    // Parse the pagination JSON string
    final pagination = jsonDecode(paginationJson) as Map<String, dynamic>;

    return LawyerResponse(
      lawyers: lawyers,
      totalCount: pagination['TotalCount'] ?? 0,
      pageSize: pagination['PageSize'] ?? 0,
      currentPage: pagination['CurrentPage'] ?? 0,
      totalPages: pagination['TotalPages'] ?? 0,
    );
  }
}
