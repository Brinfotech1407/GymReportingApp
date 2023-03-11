import 'package:json_annotation/json_annotation.dart';

//here file name and as part name both must be same
part 'gym_details.g.dart';

@JsonSerializable()
class GymDetailsModel {
  String? id;
  String? ownerId;
  String? name;
  String? address;
  String? contactNo;
  int? capacity;

  GymDetailsModel({
    this.id,
    this.ownerId,
    this.name,
    this.address,
    this.contactNo,
    this.capacity,
  });

  @override
  List<Object?> get props => [
        id,
        ownerId,
        name,
        address,
        contactNo,
        capacity,
      ];

  /// Connect the generated [_$GymDetailsFromJson] function to the `fromJson`
  /// factory.
  factory GymDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$GymDetailsModelFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$GymDetailsModelToJson(this);
}
