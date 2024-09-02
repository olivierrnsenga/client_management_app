import 'package:flutter/material.dart';

class StakeholdersTab extends StatelessWidget {
  final String projectName;

  const StakeholdersTab({super.key, required this.projectName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Stakeholders involved in project $projectName'),
    );
  }
}
