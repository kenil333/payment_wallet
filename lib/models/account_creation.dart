import 'package:json_annotation/json_annotation.dart';

import 'account_data.dart';
import 'card_data.dart';

part 'account_creation.g.dart';

@JsonSerializable()
class AccountCreation {
  AccountCreation({required this.account, required this.card});

  @JsonKey(name: 'Account')
  final AccountData account;
  @JsonKey(name: 'Card')
  final CardData card;

  factory AccountCreation.fromJson(Map<String, dynamic> json) =>
      _$AccountCreationFromJson(json);

  Map<String, dynamic> toJson() => _$AccountCreationToJson(this);
}