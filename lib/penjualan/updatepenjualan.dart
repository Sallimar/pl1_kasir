import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPenjualan extends StatefulWidget {
  final int PenjualanID;

  EditPenjualan({Key? key, required this.PenjualanID}) : super(key: key);

  @override
  State<EditPenjualan> createState() => _EditPenjualanState();
}

class _EditPenjualanState extends State<EditPenjualan> {
  final _tanggalPenjualan = TextEditingController();
  final _totalHarga = TextEditingController();
  final _pelangganID = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPenjualanData();
  }

  Future<void> _loadPenjualanData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await Supabase.instance.client
          .from('penjualan')
          .select()
          .eq('PenjualanID', widget.PenjualanID)
          .single();

      if (data == null) {
        throw Exception('Data penjualan tidak ditemukan');
      }

      setState(() {
        _tanggalPenjualan.text = data['TanggalPenjualan'] ?? '';
        _totalHarga.text = data['TotalHarga'].toString();
        _pelangganID.text = data['PelangganID'].toString();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data penjualan: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updatePenjualan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await Supabase.instance.client.from('penjualan').update({
          'TanggalPenjualan': _tanggalPenjualan.text,
          'TotalHarga': double.parse(_totalHarga.text),
          'PelangganID': int.parse(_pelangganID.text),
        }).eq('PenjualanID', widget.PenjualanID);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data penjualan berhasil diperbarui')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data penjualan: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> deletePenjualan() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Supabase.instance.client.from('penjualan').delete().eq('PenjualanID', widget.PenjualanID);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Penjualan berhasil dihapus')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus penjualan: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Penjualan'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _tanggalPenjualan,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Penjualan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal Penjualan wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _totalHarga,
                      decoration: InputDecoration(
                        labelText: 'Total Harga',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Total Harga wajib diisi';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Total Harga harus berupa angka';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _pelangganID,
                      decoration: InputDecoration(
                        labelText: 'Pelanggan ID',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pelanggan ID wajib diisi';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Pelanggan ID harus berupa angka';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: updatePenjualan,
                      child: Text('Update'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: deletePenjualan,
                      child: Text('Hapus Penjualan'),
                      style: ElevatedButton.styleFrom(iconColor: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
