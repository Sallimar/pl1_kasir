import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DetailPenjualanTab extends StatefulWidget {
  const DetailPenjualanTab({super.key});

  @override
  State<DetailPenjualanTab> createState() => _DetailPenjualanTabState();
}

class _DetailPenjualanTabState extends State<DetailPenjualanTab> {
  List<Map<String, dynamic>> detaill = [];
  List<int> selectedItems = []; // List untuk item yang dipilih
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  /// Fungsi untuk mengambil detail penjualan dari Supabase
  Future<void> fetchDetail() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .select('*, penjualan(*, pelanggan(*)), produk(*)');

      setState(() {
        detaill = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching detail penjualan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penjualan'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                color: Colors.grey,
                size: 30,
              ),
            )
          : detaill.isEmpty
              ? const Center(
                  child: Text(
                    'Detail penjualan tidak ada',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: detaill.length,
                  itemBuilder: (context, index) {
                    final detail = detaill[index];
                    final detailID = detail['DetailID'] as int? ?? -1;
                    final pelangganNama = detail['penjualan']?['pelanggan']
                            ?['NamaPelanggan']
                        ?.toString();
                    final produkNama =
                        detail['produk']?['NamaProduk']?.toString();
                    final jumlahProduk =
                        detail['JumlahProduk']?.toString() ?? 'Tidak tersedia';
                    final subtotal =
                        detail['Subtotal']?.toString() ?? 'Tidak tersedia';

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.lightGreen[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Checkbox(
                              value: selectedItems.contains(detailID),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedItems.add(detailID);
                                  } else {
                                    selectedItems.remove(detailID);
                                  }
                                });
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DetailID: ${detailID != -1 ? detailID.toString() : 'Tidak tersedia'}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Pelanggan: ${pelangganNama ?? 'Tidak tersedia'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Produk: ${produkNama ?? 'Tidak tersedia'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Jumlah: $jumlahProduk',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Subtotal: $subtotal',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
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
