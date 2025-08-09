import 'package:json_annotation/json_annotation.dart';

part 'habit_history_entry.g.dart';

/// HabitHistoryEntry
@JsonSerializable()
class HabitHistoryEntry {

  /// Yay!
  const HabitHistoryEntry({
    required this.habitName,
    required this.date,
    required this.value,
    this.notes
  });

  /// Referene to a habit this history entry refers to
  final String habitName;

  /// What date is this history entry for
  final DateTime date;

  /// Whether the habit was "completed" that date
  final bool value;

  /// Optional notes
  final String? notes;

  /// Make serializable
  Map<String, dynamic> toJson() => _$HabitHistoryEntryToJson(this);
}
