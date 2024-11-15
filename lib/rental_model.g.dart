// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RentalAdapter extends TypeAdapter<Rental> {
  @override
  final int typeId = 0;

  @override
  Rental read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rental(
      id: fields[0] as String,
      namalengkap: fields[1] as String,
      noktp: fields[2] as String,
      jenismobil: fields[3] as String,
      platnomor: fields[4] as String,
      photopath: fields[5] as String,
      daterental: fields[6] as String,
      enddaterental: fields[7] as String,
      harga: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Rental obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.namalengkap)
      ..writeByte(2)
      ..write(obj.noktp)
      ..writeByte(3)
      ..write(obj.jenismobil)
      ..writeByte(4)
      ..write(obj.platnomor)
      ..writeByte(5)
      ..write(obj.photopath)
      ..writeByte(6)
      ..write(obj.daterental)
      ..writeByte(7)
      ..write(obj.enddaterental)
      ..writeByte(8)
      ..write(obj.harga);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RentalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
