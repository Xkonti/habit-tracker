/// Helper extensions for parsing dates from strings
extension DateParsing on String {
  /// Converts a string date from year-month-day format to UTC date
  DateTime toUtcDate() {
    // split into year, month, day
    final [year, month, day] = split('-');
    return DateTime.utc(int.parse(year), int.parse(month), int.parse(day));
  }
}

/// Helper extensions for converting dates into strings
extension DateSerialization on DateTime {
  /// Converts datetime to datetime string which is surreadb friendly
  String toSurrealDateString() {
    return toString().replaceAll(' ', 'T');
  }
}
