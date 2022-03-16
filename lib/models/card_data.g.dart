// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardData _$CardDataFromJson(Map<String, dynamic> json) => CardData(
      validTill: DateTime.parse(json['validTill'] as String),
      cardId: json['cardId'] as String,
      cardNumber: json['cardNumber'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$CardDataToJson(CardData instance) => <String, dynamic>{
      'validTill': instance.validTill.toIso8601String(),
      'cardId': instance.cardId,
      'cardNumber': instance.cardNumber,
      'status': instance.status,
    };
