import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rental_mobil/rental_input.dart';
import 'package:rental_mobil/rental_list_page.dart';
import 'package:rental_mobil/rental_model.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(RentalAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sewa Mobil App',
      theme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and color
        brightness: Brightness.light,
        primaryColor: Colors.blue, // Primary color for AppBar and active elements
        hintColor: Colors.grey, // Accent color for highlights

        // Define the default AppBar theme
        appBarTheme: AppBarTheme(
          color: Colors.blue, // AppBar background color
          iconTheme: IconThemeData(color: Colors.white), // AppBar icons color
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Define button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Background color of button
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Button shape
            ),
          ),
        ),

        // FloatingActionButton theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),

        // Customize additional themes as needed...
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Key rentalListKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sewa Mobil'),
      ),
      body: Center(
        child: RentalListPage(key: rentalListKey,)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final rental = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InputRentalPage()),
          );

          if (rental == true) {
            setState(() {
              rentalListKey = UniqueKey();
            });
          }
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat,
    );
  }
}
