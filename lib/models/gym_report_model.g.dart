// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GymReportModel _$GymReportModelFromJson(Map<String, dynamic> json) =>
    GymReportModel(
      id: json['id'] as String,
      gymId: json['gymId'] as String,
      userId: json['userId'] as String,
      date: json['date'] as String,
      signInTime: json['signInTime'] as String,
      signOutTime: json['signOutTime'] as String,
      isUserSignedOutForDay: json['isUserSignedOutForDay'] as bool? ?? false,
    );

Map<String, dynamic> _$GymReportModelToJson(GymReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gymId': instance.gymId,
      'userId': instance.userId,
      'date': instance.date,
      'signInTime': instance.signInTime,
      'signOutTime': instance.signOutTime,
      'isUserSignedOutForDay': instance.isUserSignedOutForDay,
    };
