import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final Function(int) onPageChanged;

  // ignore: prefer_const_constructors_in_immutables
  PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.first_page),
          onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        Text(
          '$currentPage - ${currentPage + 9 > totalCount ? totalCount : currentPage + 9} of $totalCount',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.last_page),
          onPressed:
              currentPage < totalPages ? () => onPageChanged(totalPages) : null,
        ),
      ],
    );
  }
}
