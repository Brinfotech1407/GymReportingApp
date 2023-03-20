import 'package:json_annotation/json_annotation.dart';

//here file name and as part name both must be same
part 'gym_report_model.g.dart';

@JsonSerializable()
class GymReportModel {
  String id;
  String gymId;
  String userId;
  String date;
  String signInTime;
  String signOutTime;
  bool isUserSignedOutForDay;

  GymReportModel({
    required this.id,
    required this.gymId,
    required this.userId,
    required this.date,
    required this.signInTime,
    required this.signOutTime,
    this.isUserSignedOutForDay = false,
  });

  @override
  List<Object?> get props =>
      [id, gymId, userId, date, signInTime, signOutTime, isUserSignedOutForDay];

  /// Connect the generated [_$GymReportFromJson] function to the `fromJson`
  /// factory.
  factory GymReportModel.fromJson(Map<String, dynamic> json) =>
      _$GymReportModelFromJson(json);

  /// Connect the generated [_$ReportToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$GymReportModelToJson(this);
}
