import 'package:flutter/material.dart';
import 'package:pl1_kasir/admin/detailpenjualan/detail_penjualan.dart';
import 'package:pl1_kasir/admin/pelanggan/index.dart';
import 'package:pl1_kasir/admin/penjualan/index.dart';
import 'package:pl1_kasir/admin/produk/index.dart';
import 'package:pl1_kasir/Admin/registrasi.dart';
import 'package:pl1_kasir/login.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // Pastikan length sesuai dengan jumlah children
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _changeTab(int index) {
    setState(() {
      _tabController.index = index;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        backgroundColor: Colors.purple[100],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple[100]),
              child: Center(
                child: Text(
                  "Menu Admin",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Halaman Utama'),
              onTap: () => _changeTab(0),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Produk'),
              onTap: () => _changeTab(1),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Customer'),
              onTap: () => _changeTab(2),
            ),
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('Penjualan'),
              onTap: () => _changeTab(3),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Detail Penjualan'),
              onTap: () => _changeTab(4),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Register'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Halaman Selamat Datang
          Container(
            color: Colors.purple[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selamat Datang di Demen Ngemil",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          ProdukTab(),
          PelangganTab(),
          PenjualanTab(),
          DetailPenjualanTab(),
        ],
      ),
    );
  }
}
