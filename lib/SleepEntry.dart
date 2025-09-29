class SleepEntry {
  final String bedtime;
  final String wakeup;
  final String nap;       // in hours, e.g., "1.5"
  final String total;     // total sleep, e.g., "7h 30m"

  SleepEntry({
    required this.bedtime,
    required this.wakeup,
    required this.nap,
    required this.total,
  });

  SleepEntry copyWith({
    String? bedtime,
    String? wakeup,
    String? nap,
    String? total,
  }) {
    return SleepEntry(
      bedtime: bedtime ?? this.bedtime,
      wakeup: wakeup ?? this.wakeup,
      nap: nap ?? this.nap,
      total: total ?? this.total,
    );
  }
}
