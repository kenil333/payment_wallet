// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountData _$AccountDataFromJson(Map<String, dynamic> json) => AccountData(
      accountId: json['AccountId'] as String,
      description: json['Description'] as String,
      currency: json['Currency'] as String,
      identification: json['Identification'] as String,
      accountType: json['AccountType'] as String,
      accountSubType: json['AccountSubType'] as String,
      nickname: json['Nickname'] as String,
    );

Map<String, dynamic> _$AccountDataToJson(AccountData instance) =>
    <String, dynamic>{
      'AccountId': instance.accountId,
      'Description': instance.description,
      'Currency': instance.currency,
      'Identification': instance.identification,
      'AccountType': instance.accountType,
      'AccountSubType': instance.accountSubType,
      'Nickname': instance.nickname,
    };
