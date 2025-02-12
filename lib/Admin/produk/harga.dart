import 'package:flutter/material.dart';
import 'package:pl1_kasir/Admin/adminhomepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProdukDetailPage extends StatefulWidget {
  final Map<String, dynamic> produk;
  const ProdukDetailPage({Key? key, required this.produk}) : super(key: key);

  @override
  _ProdukDetailPageState createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
  int jumlahPesanan = 0;
  int totalHarga = 0;
  int? selectedPelangganId;
  List<Map<String, dynamic>> pelangganList = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  // Mengambil daftar pelanggan dari Supabase
  Future<void> fetchPelanggan() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('pelanggan').select('PelangganID, NamaPelanggan');

    if (response.isNotEmpty) {
      setState(() {
        pelangganList = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  // Mengupdate jumlah pesanan dan total harga
  void updateJumlahPesanan(int harga, int delta) {
    setState(() {
      jumlahPesanan += delta;
      if (jumlahPesanan < 0) jumlahPesanan = 0;
      totalHarga = jumlahPesanan * harga;
      if (totalHarga < 0) totalHarga = 0;
    });
  }

  // Fungsi untuk menyimpan data ke tabel penjualan di Supabase
  Future<void> simpanPesanan() async {
  final supabase = Supabase.instance.client;
  final produkid = widget.produk['ProdukID']; // Ambil Produkid dari widget.produk

  // Pastikan Produkid tidak null
  if (produkid == null || selectedPelangganId == null || jumlahPesanan <= 0) {
    print("Gagal menyimpan, pastikan semua data sudah lengkap.");
    return;
  }

  try {
    // Insert ke tabel penjualan
    final penjualan = await supabase.from('penjualan').insert({
      'TotalHarga': totalHarga,
      'PelangganID': selectedPelangganId,
    }).select().single();

    if (penjualan.isNotEmpty) {
      final penjualanId = penjualan['PenjualanID'];

      // Insert ke tabel detailpenjualan
      await supabase.from('detailpenjualan').insert({
        'PenjualanID': penjualanId,
        'ProdukID': produkid,
        'JumlahProduk': jumlahPesanan,
        'Subtotal': totalHarga,
      }).select().single();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
    }
  } catch (e) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
  }
}


  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final harga = produk['Harga'] ?? 0;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Produk: ${produk['NamaProduk'] ?? 'Tidak Tersedia'}', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                Text('Harga: $harga', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                Text('Stok: ${produk['Stok'] ?? 'Tidak Tersedia'}', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                
                // Dropdown untuk memilih pelanggan
                DropdownButtonFormField<int>(
                  value: selectedPelangganId,
                  items: pelangganList.map((pelanggan) {
                    return DropdownMenuItem<int>(
                      value: pelanggan['PelangganID'],
                      child: Text(pelanggan['NamaPelanggan']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPelangganId = value;
                      print("Pelanggan dipilih: $selectedPelangganId"); // Debugging
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Pilih Pelanggan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Tombol untuk mengurangi dan menambah jumlah pesanan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => updateJumlahPesanan(harga, -1),
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$jumlahPesanan', style: const TextStyle(fontSize: 20)),
                    IconButton(
                      onPressed: () => updateJumlahPesanan(harga, 1),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tombol Tutup dan Pesan
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup', style: TextStyle(fontSize: 20)),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: jumlahPesanan > 0 ? () {
                        print("Total Harga: $totalHarga, Pelanggan ID: $selectedPelangganId"); // Debugging
                        simpanPesanan();
                      } : null,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade300),
                      child: Text('Pesan ($totalHarga)', style: const TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}