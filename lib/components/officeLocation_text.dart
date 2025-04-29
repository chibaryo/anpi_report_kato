import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/firestore/officelocation/officelocation.dart';
import '../repository/firebase/officelocation_repo.dart';

class OfficeLocationText extends ConsumerWidget {
  final int? value;
  final ValueChanged<int?> onChanged;
  final int? givenSortNumber;

  const OfficeLocationText({
    super.key,
    required this.value,
    required this.onChanged,
    this.givenSortNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get repository from provider
    final officeLocationRepository = ref.watch(officeLocationRepositoryProvider);

    // Fetch single office location if givenSortNumber is provided
    final singleOfficeLocationFuture = givenSortNumber != null && givenSortNumber != 0
        ? officeLocationRepository.getOfficeLocationBySortNumber(givenSortNumber!)
        : Future.value(null);

    return FutureBuilder<OfficeLocation?>(
      future: singleOfficeLocationFuture,
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
    
        // Handle error state
        if (snapshot.hasError) {
          debugPrint('Error loading office location: ${snapshot.error}');
          return const Text('Error loading office location');
        }
    
        // Show the displayName if we're viewing (not editing)
        if (givenSortNumber != null && givenSortNumber != 0) {
          final officeLocation = snapshot.data;
          return Text(
            officeLocation?.displayName ?? '未設定',
          );
        }
    
        // If no givenSortNumber, return an empty container or some default widget
        // (or you could keep the dropdown functionality if needed)
        return Container(); // or whatever default widget you prefer
      },
    );
  }
}