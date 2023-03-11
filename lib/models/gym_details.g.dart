// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GymDetailsModel _$GymDetailsModelFromJson(Map<String, dynamic> json) =>
    GymDetailsModel(
      id: json['id'] as String?,
      ownerId: json['ownerId'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      contactNo: json['contactNo'] as String?,
      capacity: json['capacity'] as int?,
    );

Map<String, dynamic> _$GymDetailsModelToJson(GymDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'address': instance.address,
      'contactNo': instance.contactNo,
      'capacity': instance.capacity,
    };
