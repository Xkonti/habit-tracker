// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Habit _$HabitFromJson(Map<String, dynamic> json) => Habit(
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
    };

HabitResponseDto _$HabitResponseDtoFromJson(Map<String, dynamic> json) =>
    HabitResponseDto(
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$HabitResponseDtoToJson(HabitResponseDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
