import 'package:json_annotation/json_annotation.dart';

part 'account_data.g.dart';

@JsonSerializable()
class AccountData {
  AccountData({
    //required this.account,
    required this.accountId,
    required this.description,
    required this.currency,
    required this.identification,
    required this.accountType,
    required this.accountSubType,
    required this.nickname,
  });

  //@JsonKey(name: 'Account')
  //final TensoAccount account;

  @JsonKey(name: 'AccountId')
  final String accountId;

  @JsonKey(name: 'Description')
  final String description;

  @JsonKey(name: 'Currency')
  final String currency;

  @JsonKey(name: 'Identification')
  final String identification;

  @JsonKey(name: 'AccountType')
  final String accountType;

  @JsonKey(name: 'AccountSubType')
  final String accountSubType;

  @JsonKey(name: 'Nickname')
  final String nickname;

  // Implement toString to make it easier to see information about
  // each Account when using the print statement.
  @override
  String toString() {
    return 'AccountData{accountId: $accountId, identification: $identification, description: $description, currency: $currency, accountType: $accountType, '
        'accountSubType:$accountSubType, nickname:$nickname}';
  }

  /*
"AccountId": "3f6ee71f-534e-43c8-8967-3621b901200a",
"Description": "Personal",
"Currency": "CAD",
"AccountType": "Personal",
"AccountSubType": "CurrentAccount",
"Nickname": "Test
*/
  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDataToJson(this);


}
