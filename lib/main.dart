import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pl1_kasir/login.dart';
import 'package:pl1_kasir/Admin/adminhomepage.dart';
import 'package:pl1_kasir/Petugas/petugashomepage.dart';
import 'package:pl1_kasir/Admin/Registrasi.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://ksbvcvgtwxwgbqzyuvqc.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtzYnZjdmd0d3h3Z2Jxenl1dnFjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY5NTE1MjgsImV4cCI6MjA1MjUyNzUyOH0.Ka5HqO-lll21zgZdHzNG29zRWh8dG9p7c1I-TKE8Des',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super. key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Toko Alami',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black)
        )
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.purple[100],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Toko
                Image.asset(
                  'assets/logongemil.png',
                  height: 300,
               ),
                const SizedBox(height: 10),
                // Teks Selamat Datang
                const Text(
                  'Selamat Datang di Toko Kami \n Lagi galau? Demen Ngemil solusinya!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context)=> LoginPage()),);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 50,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
