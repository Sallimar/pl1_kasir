import 'package:flutter/material.dart';
import 'package:pl1_kasir/penjualan/indexpenjualan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTransaksi extends StatefulWidget {
  const AddTransaksi({super.key});

  @override
  State<AddTransaksi> createState() => _AddTransaksiState();
}

class _AddTransaksiState extends State<AddTransaksi> {
  final _tgl = TextEditingController();
  final _hrg = TextEditingController();
  final _pelanggan = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> transaksi() async {
    if (_formKey.currentState!.validate()) {
      final String tanggalPenjualan = _tgl.text;
      final double totalHarga = double.tryParse(_hrg.text) ?? 0;
      final int pelangganId = int.tryParse(_pelanggan.text) ?? 0;

      final response = await Supabase.instance.client.from('penjualan').insert([
        {
          'TanggalPenjualan': tanggalPenjualan,
          'TotalHarga': totalHarga,
          'Pelangganid': pelangganId,
        }
      ]);

      // Cek jika ada error pada response
      if (response.error != null) {
        // Tetap pindah ke halaman PenjualanTab meskipun terjadi error
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PenjualanTab()),
        );
      } else {
        // Pindah ke halaman PenjualanTab jika transaksi berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PenjualanTab()),
        );
      }
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Tambah Penjualan'),
    ),
    body: SingleChildScrollView( // Tambahkan ScrollView di sini
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tgl,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Penjualan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hrg,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Penjualan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pelanggan,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pelanggan ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pelanggan ID tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center( // Tambahkan Center agar tombol berada di tengah
                child: ElevatedButton(
                  onPressed: transaksi,
                  child: const Text('Tambah'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}