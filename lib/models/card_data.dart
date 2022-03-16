import 'package:json_annotation/json_annotation.dart';

part 'card_data.g.dart';

@JsonSerializable()
class CardData {
  CardData(
      {required this.validTill,
        required this.cardId,
        required this.cardNumber,
        required this.status});

  final DateTime validTill;
  final String cardId;
  final String cardNumber;
  final String status;

  factory CardData.fromJson(Map<String, dynamic> json) =>
      _$CardDataFromJson(json);

  Map<String, dynamic> toJson() => _$CardDataToJson(this);

  Map<String, dynamic> toMap(String accountId) {
    return {
      'validTill': validTill,
      'cardId': cardId,
      'cardNumber': cardNumber,
      'status': status,
      'accountId':accountId,
    };
  }

  @override
  String toString() {
    return 'Card{validTill: $validTill, cardId: $cardId, cardNumber: $cardNumber, status: $status}';
  }

  factory CardData.fromMap(Map<String, dynamic> data) => new CardData(
    validTill: data["validTill"],
    cardId: data["cardId"],
    cardNumber: data["cardNumber"],
    status: data["status"],
  );
}
