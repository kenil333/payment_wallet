import 'package:json_annotation/json_annotation.dart';

part 'tenso_transaction.g.dart';

/*
  {
    "Type": "DEBIT",
    "Description": "Tensopay is credited",
    "Amount": "0.2",
    "Currency": "AUD",
    "DateTime": "2022-02-03T00:10:00Z"
  }
 */
@JsonSerializable()
class TensoTransaction {
  TensoTransaction({
    required this.type,
    required this.description,
    required this.amount,
    required this.currency,
    required this.dateTime,
  });

  @JsonKey(name: 'Type')
  final String type;

  @JsonKey(name: 'Description')
  final String description;

  @JsonKey(name: 'Amount')
  final String amount;

  @JsonKey(name: 'Currency')
  final String currency;

  @JsonKey(name: 'DateTime')
  final DateTime dateTime;

  factory TensoTransaction.fromJson(Map<String, dynamic> json) =>
      _$TensoTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TensoTransactionToJson(this);
}