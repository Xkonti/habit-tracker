import 'package:json_annotation/json_annotation.dart';

part 'habit.g.dart';

/// Habit
@JsonSerializable()
class Habit {

  /// Yay!
  const Habit({required this.createdAt, required this.name});

  /// When the habit was created
  final DateTime createdAt;

  /// Habit name
  final String name;

  /// Make serializable
  Map<String, dynamic> toJson() => _$HabitToJson(this);
}
