// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Habit _$HabitFromJson(Map<String, dynamic> json) => Habit(
      createdAt: DateTime.parse(json['createdAt'] as String),
      name: json['name'] as String,
    );

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
    };
