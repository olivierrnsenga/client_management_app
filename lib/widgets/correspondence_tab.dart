import 'package:flutter/material.dart';

class CorrespondenceTab extends StatelessWidget {
  final String projectName;

  const CorrespondenceTab({super.key, required this.projectName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Correspondence related to project $projectName'),
    );
  }
}
