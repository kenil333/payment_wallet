// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenso_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TensoTransaction _$TensoTransactionFromJson(Map<String, dynamic> json) =>
    TensoTransaction(
      type: json['Type'] as String,
      description: json['Description'] as String,
      amount: json['Amount'] as String,
      currency: json['Currency'] as String,
      dateTime: DateTime.parse(json['DateTime'] as String),
    );

Map<String, dynamic> _$TensoTransactionToJson(TensoTransaction instance) =>
    <String, dynamic>{
      'Type': instance.type,
      'Description': instance.description,
      'Amount': instance.amount,
      'Currency': instance.currency,
      'DateTime': instance.dateTime.toIso8601String(),
    };
