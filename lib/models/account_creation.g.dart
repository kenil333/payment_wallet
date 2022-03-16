// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_creation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountCreation _$AccountCreationFromJson(Map<String, dynamic> json) =>
    AccountCreation(
      account: AccountData.fromJson(json['Account'] as Map<String, dynamic>),
      card: CardData.fromJson(json['Card'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountCreationToJson(AccountCreation instance) =>
    <String, dynamic>{
      'Account': instance.account,
      'Card': instance.card,
    };
