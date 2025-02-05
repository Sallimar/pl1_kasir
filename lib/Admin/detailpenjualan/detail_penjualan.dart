import 'package:flutter/material.dart';
import 'package:pl1_kasir/Admin/adminhomepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DetailPenjualanTab extends StatefulWidget {
  const DetailPenjualanTab({super.key});

  @override
  State<DetailPenjualanTab> createState() => _DetailPenjualanTabState();
}

class _DetailPenjualanTabState extends State<DetailPenjualanTab> {
  List<Map<String, dynamic>> detaill = [];
  bool isLoading = false;
  bool isOrdering = false;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('detailpenjualan').select();
      setState(() {
        detaill = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> transaksi(int pelangganID, int subtotal) async {
    setState(() {
      isOrdering = true;
    });

    try {
      final response = await Supabase.instance.client.from('penjualan').insert({
        'PelangganID': pelangganID,
        'TotalHarga': subtotal,
      }).select();

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pesanan berhasil disimpan!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan pesanan')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat memesan')),
      );
    } finally {
      setState(() {
        isOrdering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                color: Colors.grey,
                size: 30,
              ),
            )
          : detaill.isEmpty
              ? Center(
                  child: Text(
                    'Detail penjualan tidak ada',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: detaill.length,
                  itemBuilder: (context, index) {
                    final detail = detaill[index];
                    final int pelangganID = detail['PelangganID'] ?? 1;
                    final int subtotal = detail['Subtotal'] != null
                        ? (detail['Subtotal'] is int
                            ? detail['Subtotal']
                            : int.tryParse(detail['Subtotal'].toString()) ?? 0)
                        : 0;

                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.lightGreen[50],
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DetailID: ${detail['DetailID']?.toString() ?? 'Tidak tersedia'}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'PenjualanID: ${detail['PenjualanID']?.toString() ?? 'Tidak tersedia'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'ProdukID: ${detail['ProdukID']?.toString() ?? 'Tidak tersedia'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'JumlahProduk: ${detail['JumlahProduk']?.toString() ?? 'Tidak tersedia'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Subtotal: ${detail['Subtotal']?.toString() ?? 'Tidak tersedia'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: isOrdering
                                  ? null
                                  : () async {
                                      await transaksi(pelangganID, subtotal);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isOrdering
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'Pesan',
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
