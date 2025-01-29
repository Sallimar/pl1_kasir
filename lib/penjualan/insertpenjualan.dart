import 'package:flutter/material.dart';
import 'package:pl1_kasir/penjualan/indexpenjualan.dart'; // Pastikan sudah sesuai dengan import yang diperlukan
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTransaksi extends StatefulWidget {
  const AddTransaksi({super.key});

  @override
  State<AddTransaksi> createState() => _AddTransaksiState();
}

class _AddTransaksiState extends State<AddTransaksi> {
  final _tanggalpenjualancontroller = TextEditingController();
  final _totalhargacontroller = TextEditingController();
  final _pelanggancontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> transaksi() async {
    if (_formKey.currentState!.validate()) {
      final String TanggalPenjualan = _tanggalpenjualancontroller.text;
      final double TotalHarga = double.tryParse(_totalhargacontroller.text) ?? 0;
      final int PelangganID = int.tryParse(_pelanggancontroller.text) ?? 0;

      // Melakukan request insert ke Supabase
      final response = await Supabase.instance.client.from('penjualan').insert(
        {
          'TanggalPenjualan': TanggalPenjualan,
          'TotalHarga': TotalHarga,
          'PelangganID': PelangganID,
        }
      );  // Jangan lupa untuk menambahkan .execute() agar query dieksekusi
      // Cek jika ada error pada response
      if (response.error != null) {
        // Menampilkan pesan error jika transaksi gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan penjualan: ${response.error?.message}')),
        );
      } else {
        // Pindah ke halaman PenjualanTab jika transaksi berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Penjualan berhasil ditambahkan')),
        );
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
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _tanggalpenjualancontroller,
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
                  controller: _totalhargacontroller,
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
                  controller: _pelanggancontroller,
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
                Center( 
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
