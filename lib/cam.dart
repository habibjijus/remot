import 'dart:async';
import 'dart:convert'; // Untuk decoding Base64
import 'dart:typed_data'; // Untuk Uint8List
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Base64 Image Viewer',
      home: Base64ImageScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Base64ImageScreen extends StatefulWidget {
  const Base64ImageScreen({super.key});

  @override
  _Base64ImageScreenState createState() => _Base64ImageScreenState();
}

class _Base64ImageScreenState extends State<Base64ImageScreen> {
  final StreamController<String> _imageController = StreamController<String>();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Simulasi pengiriman gambar secara real-time
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Data gambar baru dalam Base64
      const String newBase64Image = "base64String";
      // Menyuntikkan gambar baru ke stream
      _imageController.add(newBase64Image);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _imageController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Base64 Image Viewer'),
      ),
      body: Center(
        child: StreamBuilder<String>(
          stream:
              _imageController.stream, // Stream yang diperbarui secara dinamis
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // Dekode string Base64 menjadi gambar
              final String base64String = snapshot.data!;
              final Uint8List bytes =
                  base64Decode(base64String.split(',').last);
              return Image.memory(bytes); // Tampilkan gambar
            } else {
              return const Text('No image data');
            }
          },
        ),
      ),
    );
  }
}
