import 'package:hive/hive.dart';
import 'rental_model.dart';

class RentalRepository {
  final String _boxName = 'rentals';

  Future<Box<Rental>> _getBox() async {
    return await Hive.openBox<Rental>(_boxName);
  }

  // Create
  Future<void> addRental(Rental rental) async {
    final box = await _getBox();
    await box.put(rental.id, rental);
  }

  // Read
  Future<List<Rental>> getRentals() async {
    final box = await _getBox();
    return box.values.toList();
  }

  // Update
  Future<void> updateRental(Rental rental) async {
    final box = await _getBox();
    await box.put(rental.id, rental);
  }

  // Delete
  Future<void> deleteRental(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}