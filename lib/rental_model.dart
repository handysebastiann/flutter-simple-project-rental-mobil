import 'package:hive/hive.dart';

part 'rental_model.g.dart';

@HiveType(typeId: 0)
class Rental extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String namalengkap;

  @HiveField(2)
  final String noktp;

  @HiveField(3)
  final String jenismobil;

  @HiveField(4)
  final String platnomor;

  @HiveField(5)
  final String photopath;

  @HiveField(6)
  final String daterental;

  @HiveField(7)
  final String enddaterental;

  @HiveField(8)
  final String harga;

  Rental({
    required this.id,
    required this.namalengkap,
    required this.noktp,
    required this.jenismobil,
    required this.platnomor,
    required this.photopath,
    required this.daterental,
    required this.enddaterental,
    required this.harga,
  });
}
