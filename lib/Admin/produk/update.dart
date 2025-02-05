import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProduk extends StatefulWidget {
  final int ProdukID; // Harus sesuai dengan yang dipanggil di index.dart

  const EditProduk({Key? key, required this.ProdukID}) : super(key: key);

  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchProdukDetail();
  }

  Future<void> fetchProdukDetail() async {
    final response = await Supabase.instance.client
        .from('produk')
        .select()
        .eq('ProdukID', widget.ProdukID)
        .single();

    if (response != null) {
      setState(() {
        namaController.text = response['NamaProduk'] ?? '';
        hargaController.text = response['Harga'].toString();
        stokController.text = response['Stok'].toString();
      });
    }
  }

  Future<void> updateProduk() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('produk').update({
          'NamaProduk': namaController.text.trim(),
          'Harga': int.parse(hargaController.text.trim()),
          'Stok': int.parse(stokController.text.trim()),
        }).eq('ProdukID', widget.ProdukID);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil diperbarui')),
        );
        Navigator.pop(context);
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
      appBar: AppBar(title: const Text('Edit Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) => value!.isEmpty ? 'Nama produk wajib diisi' : null,
              ),
              TextFormField(
                controller: hargaController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) => int.tryParse(value!) == null ? 'Masukkan angka valid' : null,
              ),
              TextFormField(
                controller: stokController,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator: (value) => int.tryParse(value!) == null ? 'Masukkan angka valid' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProduk,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
