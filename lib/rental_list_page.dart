import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rental_mobil/rental_input.dart';
import 'package:rental_mobil/rental_repository.dart';
import 'package:rental_mobil/rental_model.dart';

class RentalListPage extends StatefulWidget {
  const RentalListPage({Key? key}) : super(key: key);

  @override
  _RentalListPageState createState() => _RentalListPageState();
}

class _RentalListPageState extends State<RentalListPage> {
  final RentalRepository _repository = RentalRepository();
  List<Rental> _rentals = [];

  @override
  void initState() {
    super.initState();
    _loadRentals();
  }

  Future<void> _loadRentals() async {
    final rentals = await _repository.getRentals();
    setState(() {
      _rentals = rentals;
    });
  }

  Future<void> _deleteRental(Rental rental) async {
    // Confirm delete action
    final bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi hapus'),
          content: Text('Yakin akan menghapus Data?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel delete
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm delete
              },
            ),
          ],
        );
      },
    );

    // If the user confirmed, delete the report
    if (shouldDelete == true) {
      await _repository.deleteRental(rental.id);  // Perform deletion
      _loadRentals(); // Reload reports after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Pelanggan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16), // Space between title and list
          Expanded(
            child: ListView.builder(
              itemCount: _rentals.length,
              itemBuilder: (context, index) {
                final rental = _rentals[index];

                // Check if photoPath is available, and show either the image or a placeholder text
                Widget leadingWidget;

                if (rental.photopath != null && rental.photopath!.isNotEmpty) {
                  if (kIsWeb) {
                    // Web platform: use base64 string and display with Image.memory
                    String base64String = rental.photopath ?? '';

                    leadingWidget = base64String.isNotEmpty
                        ? Image.memory(
                      base64Decode(base64String), // Decode the cleaned base64 string
                      width: 70,  // Adjust the size as needed
                      height: 70,
                      fit: BoxFit.cover,
                    )
                        : Text(
                      'Belum ada data',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    );
                  } else {
                    // Mobile/Desktop platform: use Image.file
                    leadingWidget = Image.file(
                      File(rental.photopath!),
                      width: 40,  // Adjust the size as needed
                      height: 40,
                      fit: BoxFit.cover,
                    );
                  }
                } else {
                  leadingWidget = Text(
                    'Belum ada data',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  );
                }

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: leadingWidget, // Display the image or text
                    title: Text(rental.namalengkap),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nomor KTP : ${rental.noktp}'),
                        Text('Jenis Mobil : ${rental.jenismobil}'),
                        Text('Plat Nomor : ${rental.platnomor}'),
                        Text('Tanggal Sewa: ${rental.daterental}'),
                        Text('Tanggal Selesai Sewa : ${rental.enddaterental}'),
                        Text('Total Pembayaran : ${rental.harga}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Button
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            // Navigate to InputReportPage for editing
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InputRentalPage(rental: rental), // Pass the report to the edit page
                              ),
                            ).then((_) {
                              // Reload reports after returning from InputReportPage
                              _loadRentals();
                            });
                          },
                        ),
                        // Delete Button
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteRental(rental);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
