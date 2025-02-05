import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pl1_kasir/admin/adminhomepage.dart';  // Import halaman utama admin

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({Key? key}) : super(key: key);

  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  
  // Fungsi untuk menyimpan transaksi penjualan ke tabel penjualan
  Future<void> simpanPenjualan(int pelangganID, int totalHarga) async {
    try {
      // Untuk memunculkan tanggal penjualan saat ini
      final TanggalPenjualan = DateTime.now().toIso8601String(); 

      final response = await supabase.from('penjualan').insert({
        'TanggalPenjualan': TanggalPenjualan,
        'TotalHarga': TotalHarga,
        'PelangganID': PelangganID,
      });

      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Terjadi kesalahan: ${response.error!.message}'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Transaksi berhasil disimpan!'),
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan saat menyimpan transaksi'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    int pelangganID = 1;  
    int totalHarga = 100000;  // Total harga transaksi

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi Penjualan'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            simpanPenjualan(PelangganID, TotalHarga);
          },
          child: Text('Simpan Transaksi'),
        ),
      ),
    );
  }
}
