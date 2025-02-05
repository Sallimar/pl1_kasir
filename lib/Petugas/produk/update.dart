import 'package:flutter/material.dart';
import 'package:pl1_kasir/Petugas/petugashomepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPrdk extends StatefulWidget {
  const AddPrdk ({super.key});

  @override
  State<AddPrdk> createState() => _AddPrdkState();
}

class _AddPrdkState extends State<AddPrdk> {
  final TextEditingController NamaProdukController = TextEditingController();
  final TextEditingController HargaController = TextEditingController();
  final TextEditingController StokController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    NamaProdukController.dispose();
    HargaController.dispose();
    StokController.dispose();
    super.dispose();
  }

  Future<void> tambahproduk() async {
    if (_formKey.currentState!.validate()) {
      final String NamaProduk = NamaProdukController.text.trim();
      final int? Harga = int.tryParse(HargaController.text.trim());
      final int? Stok = int.tryParse(StokController.text.trim());

      // Validasi angka
      if (Harga == null || Stok == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harga dan Stok harus berupa angka')),
        );
        return;
      }

      try {
        // Insert data ke tabel "produk"
        await Supabase.instance.client
            .from('produk')
            .insert({
              'NamaProduk': NamaProduk,
              'Harga': Harga,
              'Stok': Stok,
            });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil ditambahkan')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PetugasHomePage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: NamaProdukController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Produk wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: HargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: StokController,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: tambahproduk,
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
