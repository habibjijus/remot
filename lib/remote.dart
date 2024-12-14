import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Kontrol extends StatefulWidget {
  const Kontrol({super.key});

  @override
  State<Kontrol> createState() => _KontrolState();
}

class _KontrolState extends State<Kontrol> {
  bool _maju = false;
  bool _mundur = false;
  bool _kiri = false;
  bool _kanan = false;
  bool _lampu = false;
  bool _box = false;

  String _kondisi = "Menunggu data...";
  String _latitude = "0.0";
  String _longitude = "0.0";
  String _base64Image = "";
  Uint8List? _decodedImage;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _fetchKondisi();
    _fetchGpsData();
    _fetchBase64Image();
  }

  Future<void> _updateControlStatus() async {
    await _dbRef.child('kontrol').set({
      'maju': _maju,
      'mundur': _mundur,
      'kiri': _kiri,
      'kanan': _kanan,
      'lampu': _lampu,
      'box': _box,
    });
  }

  void _fetchKondisi() {
    _dbRef.child('kondisi').child('1').onValue.listen((event) {
      final data = event.snapshot.value;
      setState(() {
        _kondisi = data != null ? data.toString() : "Data tidak tersedia";
      });
    });
  }

  void _fetchGpsData() {
    _dbRef.child('GPS').onValue.listen((event) {
      if (event.snapshot.value == null) {
        setState(() {
          _latitude = "0.0";
          _longitude = "0.0";
        });
        return;
      }

      try {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        setState(() {
          _latitude = data['latitude']?.toString() ?? "0.0";
          _longitude = data['longitude']?.toString() ?? "0.0";
        });
      } catch (e) {
        print("Error parsing GPS data: $e");
        setState(() {
          _latitude = "0.0";
          _longitude = "0.0";
        });
      }
    }, onError: (error) {
      print("Firebase error: $error");
      setState(() {
        _latitude = "0.0";
        _longitude = "0.0";
      });
    });
  }

  void _fetchBase64Image() {
    _dbRef.child('images').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null && data['base64String'] != null) {
        setState(() {
          _base64Image = data['base64String'];
          _decodedImage = base64Decode(
            _base64Image.replaceFirst("data:image/jpeg;base64,", ""),
          );
        });
      }
    });
  }

  void _pressMaju(bool isPressed) {
    setState(() => _maju = isPressed);
    _updateControlStatus();
  }

  void _pressMundur(bool isPressed) {
    setState(() => _mundur = isPressed);
    _updateControlStatus();
  }

  void _pressKiri(bool isPressed) {
    setState(() => _kiri = isPressed);
    _updateControlStatus();
  }

  void _pressKanan(bool isPressed) {
    setState(() => _kanan = isPressed);
    _updateControlStatus();
  }

  void _toggleLampu() {
    setState(() => _lampu = !_lampu);
    _updateControlStatus();
  }

  void _toggleBox() {
    setState(() => _box = !_box);
    _updateControlStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "KONTROL MOBIL KURIR",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 51, 102),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 245, 245, 245),
        ),
        child: Stack(
          children: [
            // Bagian Padding
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar di tengah
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: _decodedImage != null
                        ? Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.memory(
                              _decodedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(
                            child: Text(
                              "Memuat gambar...",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                  ),
                  // Tombol kontrol di tengah
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTapDown: (_) => _pressMaju(true),
                    onTapUp: (_) => _pressMaju(false),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _maju ? Colors.red : Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTapDown: (_) => _pressKiri(true),
                        onTapUp: (_) => _pressKiri(false),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _kiri ? Colors.red : Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_left,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTapDown: (_) => _pressMundur(true),
                        onTapUp: (_) => _pressMundur(false),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _mundur ? Colors.red : Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTapDown: (_) => _pressKanan(true),
                        onTapUp: (_) => _pressKanan(false),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _kanan ? Colors.red : Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            // Elemen Tetap (Tidak Terscroll)
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kondisi: $_kondisi",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 51, 102),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _toggleLampu,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: _lampu ? Colors.yellow : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lightbulb,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Lampu",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Added space between the buttons
                    GestureDetector(
                      onTap: _toggleBox,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: _box ? Colors.green : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_box,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Box",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 176, 231),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Latitude: $_latitude",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Longitude: $_longitude",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
