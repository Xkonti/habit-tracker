import 'package:json_annotation/json_annotation.dart';

part 'habit_history_entry.g.dart';

/// HabitHistoryEntry
@JsonSerializable()
class HabitHistoryEntry {

  /// Yay!
  const HabitHistoryEntry({required this.createdAt, this.notes});

  /// When was the entry logged
  final DateTime createdAt;

  /// Optional notes
  final String? notes;

  /// Make serializable
  Map<String, dynamic> toJson() => _$HabitHistoryEntryToJson(this);
}
