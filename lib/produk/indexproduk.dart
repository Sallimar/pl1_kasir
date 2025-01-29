import 'package:flutter/material.dart';
import 'package:pl1_kasir/pelanggan/indexpelanggan.dart';
import 'package:pl1_kasir/penjualan/indexpenjualan.dart';
import 'package:pl1_kasir/produk/insertproduk.dart';
import 'package:pl1_kasir/produk/updateproduk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

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
  }

  Future<void> fetchProduk() async {
  setState(() {
    isLoading = true;
  });
  try {
    final response = 
    await Supabase.instance.client.from('produk').select();
    setState(() {
      produk = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching produk: $e')),
    );
    setState(() {
      isLoading = false;
    });
  }
}

  Future<void> deleteProduk(int id) async {
    try {
      final response = await Supabase.instance.client.from('produk').delete().eq('ProdukID', id);
      fetchProduk();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting produk: $e')),
      );
    }
  }

  // Fungsi untuk menambahkan produk ke penjualan
  Future<void> addToPenjualan(Map<String, dynamic> produk) async {
  try {
    // Ambil data harga produk dan pelanggan dari state atau context
    final double totalHarga = produk['Harga']; // Misalnya harga produk
    final int pelangganID = 1; // Ambil pelanggan ID secara dinamis, misalnya dari input atau context

    final response = await Supabase.instance.client.from('penjualan').insert([
      {
        'TanggalPenjualan': DateTime.now().toIso8601String(),
        'TotalHarga': totalHarga,
        'PelangganID': pelangganID,
      }
    ]); // Jangan lupa untuk menambahkan execute()
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${produk['NamaProduk']} berhasil dibeli!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error adding to penjualan: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : produk.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 10,
                  ),
                  padding: EdgeInsets.all(8),
                  itemCount: produk.length,
                  itemBuilder: (context, index) {
                    final prdk = produk[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prdk['NamaProduk'] ?? 'Produk tidak tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              prdk['Harga'] != null
                                  ? 'Harga: ${prdk['Harga']}'
                                  : 'Harga Tidak Tersedia',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              prdk['Stok'] != null
                                  ? 'Stok: ${prdk['Stok']}'
                                  : 'Stok Tidak Tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            Divider(), //garis pemisah
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () {
                                    final ProdukID = prdk['ProdukID'] ?? 0;
                                    if (ProdukID != 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProduk(ProdukID: ProdukID),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('ID produk tidak valid')),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Hapus Produk'),
                                          content: Text(
                                              'Apakah Anda yakin ingin menghapus produk ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteProduk(prdk['ProdukID']);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Hapus'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.shopping_cart, color: Colors.green),
                                  onPressed: () {
                                    addToPenjualan(prdk); // Menambahkan produk ke penjualan
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduk()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
