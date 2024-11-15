import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rental_mobil/rental_repository.dart';
import 'package:rental_mobil/rental_model.dart';
import 'package:intl/intl.dart';

class InputRentalPage extends StatefulWidget {
  final Rental? rental;
  const InputRentalPage({super.key, this.rental});

  @override
  State<InputRentalPage> createState() => _InputRentalPageState();
}

class _InputRentalPageState extends State<InputRentalPage> {
  RentalRepository rentalRepository = RentalRepository();
  TextEditingController namalengkapController = TextEditingController();
  TextEditingController noktpController = TextEditingController();
  TextEditingController jenismobilController = TextEditingController();
  TextEditingController platnomorController = TextEditingController();
  File? selectedImage;
  String? selectedImageBase64;
  TextEditingController daterentalController = TextEditingController();
  TextEditingController enddaterentalController = TextEditingController();
  TextEditingController hargaController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // validasi

  @override
  void initState() {
    super.initState();
    if (widget.rental != null) {
      namalengkapController.text = widget.rental!.namalengkap;
      noktpController.text = widget.rental!.noktp;
      jenismobilController.text = widget.rental!.jenismobil;
      platnomorController.text = widget.rental!.platnomor;
      daterentalController.text = widget.rental!.daterental;
      enddaterentalController.text = widget.rental!.enddaterental;
      hargaController.text = widget.rental!.harga;

      // for web, use base64 string
      if (kIsWeb) {
        selectedImageBase64 = widget.rental!.photopath;
      } else {
        selectedImage = File(widget.rental!.photopath);
      }
    }
  }

  // use file_picker selct an image
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // only allow image files
    );

    if (result != null) {
      setState(() {
        if (kIsWeb) {
          // Convert selected file to base64 string for Web
          selectedImageBase64 = base64Encode(result.files.single.bytes!); // Encode bytes to base64
        } else {
          selectedImage = File(result.files.single.path!); // For Mobile, get path
        }
      });
    }
  }

  Future<void> saveRental() async{
    if (_formKey.currentState?.validate() ?? false) {
      final namalengkap = namalengkapController.text;
      final noktp = noktpController.text;
      final jenismobil = jenismobilController.text;
      final platnomor = platnomorController.text;
      final daterental = daterentalController.text;
      final enddaterental = enddaterentalController.text;
      final harga = hargaController.text;

      if (kIsWeb) {
        // For Web, save the base64 string
        if (selectedImageBase64 != null) {
          final rental = Rental(
            id: widget.rental?.id ?? UniqueKey().toString(),
            namalengkap: namalengkap,
            noktp: noktp,
            jenismobil: jenismobil,
            platnomor: platnomor,
            harga: harga,
            daterental: daterental,
            enddaterental: enddaterental,
            photopath: selectedImageBase64!, // Save base64 string for Web
          );

          if (widget.rental == null) {
            await rentalRepository.addRental(rental);
          } else {
            await rentalRepository.updateRental(rental);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mohon pilih foto mobil')),
          );
          return;
        }
      } else {
        // For Mobile, save the path
        if (selectedImage != null) {
          final rental = Rental(
            id: widget.rental?.id ?? UniqueKey().toString(),
            namalengkap: namalengkap,
            noktp: noktp,
            jenismobil: jenismobil,
            platnomor: platnomor,
            harga: harga,
            daterental: daterental,
            enddaterental: enddaterental,
            photopath: selectedImageBase64!, // Save base64 string for Web
          );

          if (widget.rental == null) {
            await rentalRepository.addRental(rental);
          } else {
            await rentalRepository.updateRental(rental);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mohon pilih foto mobil')),
          );
        }
      }

      Navigator.of(context).pop(true);
    }
  }

  Future<void> _dateRental(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        // Format the date to dd-MM-yyyy
        daterentalController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _endDateRental(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        // Format the date to dd-MM-yyyy
        enddaterentalController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rental == null ? 'Tambah Data Pelanggan' : 'Edit Data Pelanggan'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: namalengkapController,
                decoration:
                InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Lengkap tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: noktpController,
                decoration: InputDecoration(
                    labelText: 'Nomor KTP',
                    border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor KTP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: jenismobilController,
                decoration: InputDecoration(
                    labelText: 'Jenis Mobil',
                    border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis Mobil tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: platnomorController,
                decoration: InputDecoration(
                    labelText: 'Plat Nomor',
                    border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Plat Nomor tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Foto Mobil'),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: _pickImage,
                child: (kIsWeb && selectedImageBase64 != null)
                    ? Image.memory(
                  base64Decode(selectedImageBase64!),
                  height: 150,
                ) // For Web, display image from base64
                    : (selectedImage != null
                    ? Image.file(selectedImage!, height: 150) // For Mobile, display image file
                    : Container(
                  color: Colors.grey[300],
                  height: 150,
                  width: double.infinity,
                  child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                )),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _dateRental(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: daterentalController,
                    decoration: InputDecoration(
                        labelText: 'Tanggal Sewa',
                        border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _endDateRental(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: enddaterentalController,
                    decoration: InputDecoration(
                        labelText: 'Tanggal Selesai Sewa',
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: hargaController,
                decoration: InputDecoration(
                    labelText: 'Total Pembayaran',
                    border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Total Pembayaran tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0,),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: saveRental,
                  child: Text(widget.rental == null ? 'Simpan' : 'Perbarui'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
