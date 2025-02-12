import 'package:flutter/material.dart';
import 'package:pl1_kasir/Admin/pelanggan/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPelanggan extends StatefulWidget {
  @override
  State<AddPelanggan> createState() => _AddPelangganState();
}

class _AddPelangganState extends State<AddPelanggan> {
  final _nmplg = TextEditingController();
  final _alamat = TextEditingController();
  final _notlp = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> langgan() async {
    if (_formKey.currentState!.validate()) {
      final String NamaPelanggan = _nmplg.text;
      final String Alamat = _alamat.text;
      final String NomorTelepon = _notlp.text;

      try {
        await Supabase.instance.client.from('pelanggan').insert({
          'NamaPelanggan': NamaPelanggan,
          'Alamat': Alamat,
          'NomorTelepon': NomorTelepon,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pelanggan berhasil ditambahkan')),
        );

        // Kembali ke halaman sebelumnya (PelangganTab) dan kirim sinyal bahwa data telah diperbarui
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PelangganTab()),);
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
        title: Text('Tambah Pelanggan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nmplg,
                decoration: InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _alamat,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _notlp,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon wajib diisi';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Nomor telepon hanya boleh angka';
                  }
                  if (value.length < 10) {
                    return 'Nomor telepon minimal 10 digit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: langgan,
                child: Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
