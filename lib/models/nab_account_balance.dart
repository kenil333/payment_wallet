import 'package:json_annotation/json_annotation.dart';
/*
{
"accountId": "23aa4b7b-3ea6-473c-ba84-2ac33bcff0c6",
"currentBalance": "238.35",
"currency": "AUD",
"availableBalance": "238.35"
}
 */

part 'nab_account_balance.g.dart';

@JsonSerializable()
class NABAccountBalance {
  NABAccountBalance({
    required this.accountId,
    required this.currentBalance,
    required this.currency,
    required this.availableBalance,
  });


  final String accountId;
  final String currentBalance;
  final String currency;
  final String availableBalance;

  factory NABAccountBalance.fromJson(Map<String, dynamic> json) =>
      _$NABAccountBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$NABAccountBalanceToJson(this);
}