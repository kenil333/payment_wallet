// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenso_bank_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TensoAccountAdapter extends TypeAdapter<TensoAccount> {
  @override
  final int typeId = 0;

  @override
  TensoAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TensoAccount(
      accountId: fields[0] as String,
      description: fields[1] as String,
      currency: fields[2] as String,
      identification: fields[3] as String,
      accountType: fields[4] as String,
      accountSubType: fields[5] as String,
      nickname: fields[6] as String,
      validTill: fields[7] as DateTime,
      cardId: fields[8] as String,
      cardNumber: fields[9] as String,
      status: fields[10] as String,
      balance: fields[11] as double,
      bankName: fields[12] as String,
      colour: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TensoAccount obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.accountId)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.currency)
      ..writeByte(3)
      ..write(obj.identification)
      ..writeByte(4)
      ..write(obj.accountType)
      ..writeByte(5)
      ..write(obj.accountSubType)
      ..writeByte(6)
      ..write(obj.nickname)
      ..writeByte(7)
      ..write(obj.validTill)
      ..writeByte(8)
      ..write(obj.cardId)
      ..writeByte(9)
      ..write(obj.cardNumber)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.balance)
      ..writeByte(12)
      ..write(obj.bankName)
      ..writeByte(13)
      ..write(obj.colour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TensoAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
