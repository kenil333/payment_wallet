// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountBalance _$AccountBalanceFromJson(Map<String, dynamic> json) =>
    AccountBalance(
      currency: json['Currency'] as String,
      amount: json['Amount'] as String,
    );

Map<String, dynamic> _$AccountBalanceToJson(AccountBalance instance) =>
    <String, dynamic>{
      'Amount': instance.amount,
      'Currency': instance.currency,
    };
