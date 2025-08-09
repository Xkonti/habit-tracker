// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_history_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitHistoryEntry _$HabitHistoryEntryFromJson(Map<String, dynamic> json) =>
    HabitHistoryEntry(
      habitName: json['habitName'] as String,
      date: DateTime.parse(json['date'] as String),
      value: json['value'] as bool,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$HabitHistoryEntryToJson(HabitHistoryEntry instance) =>
    <String, dynamic>{
      'habitName': instance.habitName,
      'date': instance.date.toIso8601String(),
      'value': instance.value,
      'notes': instance.notes,
    };
