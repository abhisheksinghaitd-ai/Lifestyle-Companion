import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifestyle_companion/SleepEntry.dart';

class SleepNotifier extends StateNotifier<List<SleepEntry>> {
  SleepNotifier() : super([]);

  // Add a full new entry
  void addSleepEntry({
    required String bedtime,
    required String wakeup,
    required String nap,
    required String total,
  }) {
    state = [
      ...state,
      SleepEntry(
        bedtime: bedtime,
        wakeup: wakeup,
        nap: nap,
        total: total,
      ),
    ];
  }

  // Update last entry (optional)
  void updateLastEntry({
    String? bedtime,
    String? wakeup,
    String? nap,
    String? total,
  }) {
    if (state.isEmpty) return;

    final last = state.last;
    final updated = last.copyWith(
      bedtime: bedtime,
      wakeup: wakeup,
      nap: nap,
      total: total,
    );

    state = [
      ...state.sublist(0, state.length - 1),
      updated,
    ];
  }
}
