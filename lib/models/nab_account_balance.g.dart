// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nab_account_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NABAccountBalance _$NABAccountBalanceFromJson(Map<String, dynamic> json) =>
    NABAccountBalance(
      accountId: json['accountId'] as String,
      currentBalance: json['currentBalance'] as String,
      currency: json['currency'] as String,
      availableBalance: json['availableBalance'] as String,
    );

Map<String, dynamic> _$NABAccountBalanceToJson(NABAccountBalance instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'currentBalance': instance.currentBalance,
      'currency': instance.currency,
      'availableBalance': instance.availableBalance,
    };
