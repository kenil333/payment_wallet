import 'package:json_annotation/json_annotation.dart';
part 'tenso_payment_data.g.dart';

@JsonSerializable()
class TensoPayment {
  final String bankName;
  final String nickName;
  final double amount;
  final String identification;
  final String currency;
  final String description;

  TensoPayment(
      {required this.bankName,
        required this.amount,
        required this.nickName,
        required this.identification,
        required this.currency,
        required this.description});

  factory TensoPayment.fromJson(Map<String, dynamic> json) =>
      _$TensoPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$TensoPaymentToJson(this);

  @override
  String toString() {
    return '{ \"bankName\": \"${this.bankName}\", \"nickName\":\"${this.nickName}\",\"identification\":\"${this.identification}\",\"amount\": ${this.amount},\"description\": \"${this.description}\"}';
  }
}
