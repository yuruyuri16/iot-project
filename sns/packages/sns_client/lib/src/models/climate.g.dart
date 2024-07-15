// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'climate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Climate _$ClimateFromJson(Map<String, dynamic> json) => Climate(
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
