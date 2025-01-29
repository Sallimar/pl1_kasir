import 'package:flutter/material.dart';
import 'package:pl1_kasir/home_page.dart';
import 'package:pl1_kasir/screens/Register.dart';
import 'package:pl1_kasir/main.dart';
import 'package:pl1_kasir/pelanggan/indexpelanggan.dart';
import 'package:pl1_kasir/penjualan/indexpenjualan.dart';
import 'package:pl1_kasir/produk/indexproduk.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1, 
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'DEMEN NGEMIL',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Pengaturan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.store),
                title: Text('Produk'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProdukTab()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text('Log Out'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProdukTab(),
          ],
        ),
      ),
    );
  }
}
