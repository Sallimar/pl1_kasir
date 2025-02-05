import 'package:flutter/material.dart';
import 'package:pl1_kasir/Petugas/petugashomepage.dart';
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
    _tabController = TabController(length: 4, vsync: this);
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
      appBar: AppBar(title: Text("Admin"),
      backgroundColor: Colors.green,),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Nessa"),
              accountEmail: Text("sallimarxpplg1@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: 
                AssetImage('assets/logo2.png'), 
                ),
              decoration: BoxDecoration(color: Colors.lightGreen), // Warna latar belakang
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Produk'),
              onTap: () => _changeTab(0),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Customer'),
              onTap: () => _changeTab(1),
            ),
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('Penjualan'),
              onTap: () => _changeTab(2),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Detail Penjualan'),
              onTap: () => _changeTab(3),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Register'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProdukTab(),
          PelangganTab(),
          PenjualanTab(),
          DetailPenjualanTab(),
        ],
      ),
    );
  }
}
