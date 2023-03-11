import 'package:json_annotation/json_annotation.dart';

//here file name and as part name both must be same
part 'user.g.dart';

@JsonSerializable()
class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? age;
  String? gender;
  String? email;
  String? mobileNo;
  String? password;
  String? deviceToken;
  int? userType;
  int? memberShipPlan;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.email,
    this.mobileNo,
    this.password,
    this.userType,
    this.deviceToken,
    this.memberShipPlan,
  });

  @override
  List<Object?> get props =>
      [
        id,
        firstName,
        lastName,
        age,
        gender,
        email,
        mobileNo,
        password,
        userType,
        deviceToken,
        memberShipPlan,
      ];

  /// Connect the generated [_$UserFromJson] function to the `fromJson`
  /// factory.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
