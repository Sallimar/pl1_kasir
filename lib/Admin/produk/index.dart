import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pl1_kasir/Admin/adminhomepage.dart';
import 'package:pl1_kasir/Admin/produk/insert.dart';
import 'package:pl1_kasir/Admin/produk/update.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pl1_kasir/Admin/produk/harga.dart';

class ProdukTab extends StatefulWidget {
  @override
  _ProdukTabState createState() => _ProdukTabState();
}

class _ProdukTabState extends State<ProdukTab> {
  List<Map<String, dynamic>> produk = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduk();

    Supabase.instance.client
    .from('produk')
    .stream(primaryKey: ['ProdukID']) 
    .eq('ProdukID', 'produk') 
    .listen((List<Map<String, dynamic>> data) {
      fetchProduk(); 
    });

  }

  Future<void> fetchProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching produk: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteProduk(int produkID) async {
    try {
      await Supabase.instance.client.from('produk').delete().eq('ProdukID', produkID);
      fetchProduk(); // Perbarui data setelah penghapusan
    } catch (e) {
      print('Error deleting produk: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Produk', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (cotext)=>AdminHomePage()),);
          }, 
          icon: Icon(Icons.arrow_back, color: Colors.black,))
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : produk.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: produk.length,
                  itemBuilder: (context, index) {
                    final produkItem = produk[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProdukDetailPage(produk: produkItem),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produkItem['NamaProduk']?.toString() ?? 'Produk tidak tersedia',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: 4),
                              Text(
                                produkItem['Harga']?.toString() ?? 'Harga Tidak tersedia',
                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                produkItem['Stok']?.toString() ?? 'Stok Tidak tersedia',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                textAlign: TextAlign.justify,
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                    onPressed: () {
                                      final produkID = produkItem['ProdukID'] ?? 0;
                                      if (produkID != 0) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditProduk(ProdukID: produkID),
                                          ),
                                        ).then((result) {
                                          if (result == true) {
                                            fetchProduk(); // Perbarui daftar produk setelah edit
                                          }
                                        });
                                      } else {
                                        print('ID produk tidak valid');
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Hapus Produk'),
                                            content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteProduk(produkItem['ProdukID']);
                                                  Navigator.pop(context); // Tutup dialog setelah hapus
                                                },
                                                child: const Text('Hapus'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProduk()),
          ).then((result) {
            if (result == true) {
              fetchProduk(); // Perbarui daftar setelah menambah produk
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
