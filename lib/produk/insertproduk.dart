import 'package:flutter/material.dart';
import 'package:pl1_kasir/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProduk extends StatefulWidget {
  const AddProduk({super.key});

  @override
  State<AddProduk> createState() => _AddProdukState();
}

class _AddProdukState extends State<AddProduk> {
  final _nmprdk = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> prdk() async {
    if (_formKey.currentState!.validate()) {
      final String NamaProduk = _nmprdk.text;
      final String Harga = _harga.text;
      final String Stok = _stok.text;

      try {
        final response = await Supabase.instance.client.from('produk').insert([
          {
            'NamaProduk': NamaProduk,
            'Harga': Harga,
            'Stok': Stok,
          }
        ]);

        if (response.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan produk: ${response.error!.message}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil ditambahkan')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        }
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
                controller: _nmprdk,
                decoration: const InputDecoration(
                  labelText: 'NamaProduk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Barang wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _harga,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stok,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'stok barang wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: prdk,
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
