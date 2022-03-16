import 'package:json_annotation/json_annotation.dart';
part 'rate.g.dart';

@JsonSerializable()
class Rate {
  Rate(
      {required this.rate});

  final double rate;

  factory Rate.fromJson(Map<String, dynamic> json) =>
      _$RateFromJson(json);

  Map<String, dynamic> toJson() => _$RateToJson(this);
}