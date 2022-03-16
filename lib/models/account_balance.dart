import 'package:json_annotation/json_annotation.dart';

part 'account_balance.g.dart';
/*
{
  "Amount": "0.00",
  "Currency": "CAD"
}
 */
@JsonSerializable()
class AccountBalance {
  AccountBalance({ required this.currency, required this.amount});

  @JsonKey(name: 'Amount')
  final String amount;

  @JsonKey(name: 'Currency')
  final String currency;

  factory AccountBalance.fromJson(Map<String, dynamic> json) =>
      _$AccountBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$AccountBalanceToJson(this);
}