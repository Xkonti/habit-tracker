import 'package:json_annotation/json_annotation.dart';

part 'habit.g.dart';

/// Habit
@JsonSerializable()
class Habit {

  /// Creates new habit entry
  const Habit({
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.name,
    required this.description,
  });

  /// Create new habit from just a name and description
  Habit.manual(this.name, [this.description = '']) :
    createdAt = DateTime.now(), updatedAt = DateTime.now(), deletedAt = null;

  /// When the habit was created
  final DateTime createdAt;

  /// When the habit was last updated
  final DateTime updatedAt;

  /// When the habit was marked as deleted
  final DateTime? deletedAt;

  /// Habit name
  final String name;

  /// Habit description
  final String description;

  /// Make serializable
  Map<String, dynamic> toJson() => _$HabitToJson(this);
}

/// Habit Response DTO
@JsonSerializable()
class HabitResponseDto {

  /// Creates new habit entry
  const HabitResponseDto({
    required this.name,
    required this.description,
  });

  /// Habit name
  final String name;

  /// Habit description
  final String description;

  /// Make serializable
  Map<String, dynamic> toJson() => _$HabitResponseDtoToJson(this);
}
