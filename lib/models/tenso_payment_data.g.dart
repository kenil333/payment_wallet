// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenso_payment_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TensoPayment _$TensoPaymentFromJson(Map<String, dynamic> json) => TensoPayment(
      bankName: json['bankName'] as String,
      amount: (json['amount'] as num).toDouble(),
      nickName: json['nickName'] as String,
      identification: json['identification'] as String,
      currency: json['currency'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$TensoPaymentToJson(TensoPayment instance) =>
    <String, dynamic>{
      'bankName': instance.bankName,
      'nickName': instance.nickName,
      'amount': instance.amount,
      'identification': instance.identification,
      'currency': instance.currency,
      'description': instance.description,
    };
