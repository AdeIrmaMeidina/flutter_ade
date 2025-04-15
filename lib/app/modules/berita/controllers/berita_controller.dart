import 'dart:convert';

import 'package:flutter_ade/app/data/berita_response.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BeritaController extends GetxController {
  var isLoading = false.obs;
  var beritaList = <Berita>[].obs;

  final connect = GetConnect(); // ✅ Reuse instance

  @override
  void onInit() {
    super.onInit();
    fetchBerita();
  }

  Future<void> fetchBerita() async {
    try {
      isLoading(true);
      print("📡 Fetching berita...");

      final token = GetStorage().read('access_token');
      print('🔐 Access token: $token');

      if (token == null) {
        print('❌ Token tidak ditemukan. Pastikan user sudah login.');
        throw Exception('User belum login');
      }

      final response = await connect.get(
        'http://10.10.11.77:8000/api/berita',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          print(
              "❌ Timeout: Server tidak merespon dalam waktu yang ditentukan.");
          return Response(body: 'Timeout Error', statusCode: 408);
        },
      );

      print('📦 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Ensure the response is decoded into a map
        Map<String, dynamic> body;
        if (response.body is String) {
          body = jsonDecode(response.body); // Decode if it's a String
        } else {
          body = response.body
              as Map<String, dynamic>; // Otherwise, assume it's already a map
        }

        final beritaResponse = BeritaResponse.fromJson(body);
        beritaList.assignAll(beritaResponse.berita ?? []);
        print('✅ ${beritaList.length} berita ditemukan');
      } else if (response.statusCode == 401) {
        print("❌ Token tidak valid / expired");
        throw Exception('Akses tidak diizinkan. Silakan login ulang.');
      } else {
        throw Exception('Gagal memuat data berita');
      }
    } catch (e) {
      print('❌ Error saat ambil berita: $e');
      Get.snackbar('Error', e.toString()); // Show error to the UI
    } finally {
      isLoading(false);
      print('✅ Selesai load');
    }
  }
}
