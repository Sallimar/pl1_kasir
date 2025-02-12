import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<int?> insertPenjualan(int pelangganID, int totalHarga) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase
        .from('penjualan')
        .insert({
          'TanggalPenjualan': DateTime.now().toIso8601String(),
          'TotalHarga': totalHarga,
          'PelangganID': pelangganID,
        })
        .select('PenjualanID')
        .maybeSingle(); // Gunakan maybeSingle agar tidak error jika kosong

    if (response == null) {
      debugPrint('Gagal menyimpan transaksi: Response null');
      return null;
    }

    return response['PenjualanID']; // Ambil ID transaksi baru
  } catch (e) {
    debugPrint('Error saat menyimpan transaksi: $e');
    return null;
  }
}
