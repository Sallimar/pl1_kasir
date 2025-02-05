import 'package:flutter/material.dart';
import 'package:pl1_kasir/Petugas/detailpenjualan/detailpenjualan.dart';
import 'package:pl1_kasir/admin/pelanggan/index.dart';
import 'package:pl1_kasir/admin/penjualan/index.dart';
import 'package:pl1_kasir/admin/produk/index.dart';
import 'package:pl1_kasir/admin/registrasi.dart';
import 'package:pl1_kasir/login.dart';


class PetugasHomePage extends StatelessWidget {
  const PetugasHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.category, color: Colors.green.shade800), text: 'Produk'),
              Tab(icon: Icon(Icons.people, color: Colors.green.shade800), text: 'Customer'),
              Tab(icon: Icon(Icons.receipt_long, color: Colors.green.shade800), text: 'Penjualan'),
              Tab(icon: Icon(Icons.assignment, color: Colors.green.shade800), text: 'Detail Penjualan'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 100,
                child: DrawerHeader(
                  child: ListTile(
                    leading: Icon(Icons.arrow_back),
                    title: Text(
                      'Pengaturan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PetugasHomePage()),
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text('Log Out'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProdukTab(),
            PelangganTab(),
            PenjualanTab(),
            DetailPenjualanTab(),
          ],
        ),
      ),
    );
  }
}

