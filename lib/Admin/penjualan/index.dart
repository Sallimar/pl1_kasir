import 'package:flutter/material.dart';
import 'package:pl1_kasir/Admin/adminhomepage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PenjualanTab extends StatefulWidget {
  @override
  _PenjualanTabState createState() => _PenjualanTabState();
}

class _PenjualanTabState extends State<PenjualanTab> {
  List<Map<String, dynamic>> penjualan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchpenjualan();
  }

  Future<void> fetchpenjualan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('penjualan').select('*, pelanggan(*)');
      setState(() {
        penjualan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching penjualan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteBarang(int id) async {
    try {
      await Supabase.instance.client.from('penjualan').delete().eq('PenjualanID', id);
      fetchpenjualan();
    } catch (e) {
      print('Error deleting barang: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penjualan'),
        backgroundColor: Colors.purple[100],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => AdminHomePage()),
            );
          }, 
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), 
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.grey, 
                  size: 30,
                ),
              )
            : penjualan.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada penjualan',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Warna agar kontras di background
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12, // Menambah jarak antar card
                    ),
                    itemCount: penjualan.length,
                    itemBuilder: (context, index) {
                      final jual = penjualan[index];
                      return Card(
                        color: Colors.white.withOpacity(0.9), // Card semi transparan
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                jual['TanggalPenjualan'] ?? 'Tanggal tidak tersedia',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total Harga: ${jual['TotalHarga']?.toString() ?? 'Tidak tersedia'}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 14, color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pelanggan ID: ${jual['pelanggan']['NamaPelanggan']?.toString() ?? 'Tidak tersedia'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14,
                                ),
                              ),
                              const Divider(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Hapus Penjualan'),
                                          content: const Text('Apakah Anda yakin ingin menghapus penjualan ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text(
                                                'Batal',
                                                style: TextStyle(color: Colors.blue),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteBarang(jual['PenjualanID']);
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Hapus',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          }
