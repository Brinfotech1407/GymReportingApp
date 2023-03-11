// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      age: json['age'] as String?,
      gender: json['gender'] as String?,
      email: json['email'] as String?,
      mobileNo: json['mobileNo'] as String?,
      password: json['password'] as String?,
      userType: json['userType'] as int?,
      deviceToken: json['deviceToken'] as String?,
      memberShipPlan: json['memberShipPlan'] as int?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
      'gender': instance.gender,
      'email': instance.email,
      'mobileNo': instance.mobileNo,
      'password': instance.password,
      'deviceToken': instance.deviceToken,
      'userType': instance.userType,
      'memberShipPlan': instance.memberShipPlan,
    };
