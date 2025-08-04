// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_history_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitHistoryEntry _$HabitHistoryEntryFromJson(Map<String, dynamic> json) =>
    HabitHistoryEntry(
      createdAt: DateTime.parse(json['createdAt'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$HabitHistoryEntryToJson(HabitHistoryEntry instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'notes': instance.notes,
    };
