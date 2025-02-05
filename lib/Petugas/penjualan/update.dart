import 'package:flutter/material.dart';
import 'package:pl1_kasir/Admin/adminhomepage.dart';
import 'package:pl1_kasir/Petugas/petugashomepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PenjualanUpdate extends StatefulWidget {
  final int Penjualanid;

  const PenjualanUpdate({super.key, required this.Penjualanid});

  @override
  State<PenjualanUpdate> createState() => _PenjualanUpdateState();
}

class _PenjualanUpdateState extends State<PenjualanUpdate> {
  final _tglController = TextEditingController();
  final _subController = TextEditingController();
  final _pelangganController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadPenjualanData();
  }

  Future<void> _loadPenjualanData() async {
    try {
      final data = await Supabase.instance.client
          .from('penjualan')
          .select()
          .eq('Penjualanid', widget.Penjualanid)
          .single();

      setState(() {
        _tglController.text = data['TanggalPenjualan'] ?? '';
        _subController.text = data['TotalHarga']?.toString() ?? '';
        _pelangganController.text = data['Pelangganid'] ?? '';
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $error')),
      );
    }
  }

  Future<void> _updatePenjualan() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('penjualan').update({
          'TanggalPenjualan': _tglController.text,
          'TotalHarga': double.tryParse(_subController.text) ?? 0,
          'Pelangganid': _pelangganController.text,
        }).eq('Penjualanid', widget.Penjualanid);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PetugasHomePage()),
          (route) => false,
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating data: $error')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tglController.dispose();
    _subController.dispose();
    _pelangganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Penjualan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tglController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Penjualan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Penjualan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _subController,
                decoration: InputDecoration(
                  labelText: 'Total Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _pelangganController,
                decoration: InputDecoration(
                  labelText: 'Pelanggan ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pelanggan ID tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updatePenjualan,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


