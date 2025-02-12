import 'package:flutter/material.dart';
import 'package:pl1_kasir/Admin/adminhomepage.dart';
import 'package:pl1_kasir/Admin/pelanggan/insert.dart';
import 'package:pl1_kasir/Admin/pelanggan/update.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganTab extends StatefulWidget {
  @override
  _PelangganTabState createState() => _PelangganTabState();
}

class _PelangganTabState extends State<PelangganTab> {
  List<Map<String, dynamic>> pelanggan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchpelanggan();
  }

  Future<void> fetchpelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching pelanggan: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletepelanggan(int id) async {
    try {
      await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('PelangganID', id);
      fetchpelanggan();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pelanggan berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting pelanggan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Custommers',
          style: TextStyle(color: Colors.black),
        ), backgroundColor: Colors.purple[200],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context)=> AdminHomePage()),);
          }, 
          icon: Icon(Icons.arrow_back),),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), 
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : pelanggan.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada pelanggan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Warna teks agar kontras
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: pelanggan.length,
                    itemBuilder: (context, index) {
                      final langgan = pelanggan[index];
                      return Card(
                        color: Colors.white.withOpacity(0.9), // Card semi transparan
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                langgan['NamaPelanggan'] ?? 'Pelanggan tidak tersedia',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                langgan['Alamat'] ?? 'Alamat tidak tersedia',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                               SizedBox(height: 8),
                              Text(
                                (langgan['NomorTelepon'] != null &&
                                        RegExp(r'^[0-9]+$')
                                            .hasMatch(langgan['NomorTelepon']))
                                    ? langgan['NomorTelepon']
                                    : 'Nomor telepon tidak valid',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: (langgan['NomorTelepon'] != null &&
                                          RegExp(r'^[0-9]+$')
                                              .hasMatch(langgan['NomorTelepon']))
                                      ? Colors.black
                                      : Colors.red, // Warna merah untuk nomor tidak valid
                                ),
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blueAccent),
                                    onPressed: () {
                                      final pelangganID = langgan['PelangganID'] ?? 0;
                                      if (pelangganID != 0) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditPelanggan(
                                              PelangganID: pelangganID,
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('ID pelanggan tidak valid')),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Hapus Pelanggan'),
                                            content: Text('Apakah Anda yakin ingin menghapus pelanggan ini?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text(
                                                  'Batal',
                                                  style: TextStyle(color: Colors.blueAccent),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deletepelanggan(langgan['PelangganID']);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Hapus',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPelanggan()),
          );
        },
        child: Icon(Icons.add, color: Colors.blueAccent),
        backgroundColor: Colors.white,
      ),
    );
  }
}
