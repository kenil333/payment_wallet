import 'dart:ui';

import 'package:hive/hive.dart';

part 'tenso_bank_account.g.dart';

@HiveType(typeId: 0)
class TensoAccount extends HiveObject{
  TensoAccount({
    required this.accountId,
    required this.description,
    required this.currency,
    required this.identification,
    required this.accountType,
    required this.accountSubType,
    required this.nickname,
    required this.validTill,
    required this.cardId,
    required this.cardNumber,
    required this.status,
    required this.balance,
    required this.bankName,
    required this.colour,
  });

  @HiveField(0)
  String accountId;

  @HiveField(1)
  String description;

  @HiveField(2)
  String currency;

  @HiveField(3)
  String identification;

  @HiveField(4)
  String accountType;

  @HiveField(5)
  String accountSubType;

  @HiveField(6)
  String nickname;

  @HiveField(7)
  DateTime validTill;

  @HiveField(8)
  String cardId;

  @HiveField(9)
  String cardNumber;

  @HiveField(10)
  String status;

  @HiveField(11)
  double balance;

  @HiveField(12)
  String bankName;

  @HiveField(13)
  int colour;

}