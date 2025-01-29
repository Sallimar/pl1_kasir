import 'package:flutter/material.dart';
import 'package:pl1_kasir/screens/Register.dart';
import 'package:pl1_kasir/main.dart';
import 'package:pl1_kasir/pelanggan/indexpelanggan.dart';
import 'package:pl1_kasir/penjualan/indexpenjualan.dart';
import 'package:pl1_kasir/produk/indexproduk.dart';


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar( 
          title: Text('Dashboard', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors. green[300],
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4.0,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.analytics_outlined, color: Colors.white70,), text: 'Detail Penjualan'),
              Tab(icon: Icon(Icons.inventory, color: Colors.white70,), text: 'Produk'),
              Tab(icon: Icon(Icons.groups, color: Colors.white70,), text: 'Customer'),
              Tab(icon: Icon(Icons.sell, color: Colors.white70,), text: 'Penjualan'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
             padding: EdgeInsets.zero,
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
                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text('Log Out'),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context)=> MainPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Detail Penjualan')),
            ProdukTab(),
            PelangganTab(),
            PenjualanTab(),
          ],
        ),
      ),
    );
  }
}

