import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:remotkontrol/firebase_options.dart';
import 'package:remotkontrol/remote.dart'; // Pastikan file remote.dart sudah ada dan diimpor dengan benar

void main() async {
  // Menunggu inisialisasi Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Pastikan file firebase_options.dart ada dan benar
  );

  // Menjalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Remote Kurir",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) =>
            const Kontrol(), // Pastikan Kontrol ada di remote.dart
      },
    );
  }
}
