import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/profile_response.dart';
import '../../../utils/api.dart';

class ProfileController extends GetxController {
  final box = GetStorage();
  final _getConnect = GetConnect();

  var profile = Rxn<ProfileResponse>(); // Menggunakan Rxn untuk nullable data
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  /// 🔐 Mengambil token dari storage
  Future<String?> getToken() async {
    String? token = box.read('token') ?? box.read('auth_token');
    debugPrint('🔑 Retrieved token: $token');
    return token;
  }

  /// 📄 Mengambil data profil dari API
  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      update();

      String? token = await getToken();
      debugPrint("🔑 Token: $token");

      if (token == null || token.isEmpty) {
        throw Exception("⚠️ Token tidak ditemukan, silakan login ulang.");
      }

      final response = await _getConnect.get(
        '${BaseUrl.baseUrl}${BaseUrl.profile}',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      debugPrint("📡 Response Status: ${response.statusCode}");
      debugPrint("📦 Response Body: ${response.body}");

      if (response.status.hasError) {
        if (response.statusCode == 401) {
          await logout();
          throw Exception("⚠️ Sesi berakhir, silakan login kembali.");
        }
        throw Exception("❌ Gagal mengambil profil: ${response.statusText}");
      }

      final rawData = response.body;
      debugPrint("📝 Data yang diterima dari API: $rawData");

      if (rawData == null) {
        throw Exception("⚠️ API mengembalikan response kosong.");
      }

      if (rawData is! Map<String, dynamic>) {
        throw Exception(
            "❌ Format response API salah. Harus berupa JSON Object.");
      }

      // **Sekarang langsung parsing JSON tanpa field `data`**
      profile.value = ProfileResponse.fromJson(rawData);
      debugPrint("✅ Profil berhasil dimuat: ${profile.value}");
    } catch (e) {
      debugPrint("❌ Error saat mengambil profil: $e");
      showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// 🔴 Logout pengguna dan hapus data
  Future<void> logout() async {
    try {
      debugPrint("🚪 Logging out...");

      // Hapus token & data profil
      await box.erase();
      Get.delete<ProfileController>(); // Hapus controller lama
      Get.put(ProfileController()); // Buat ulang controller baru

      profile.value = null; // Reset data user
      update(); // Perbarui UI

      // Pindah ke halaman login
      Get.offAllNamed('/login');
    } catch (e) {
      debugPrint("❌ Error saat logout: $e");
      Get.snackbar(
        "Error",
        "Gagal logout: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// ⚠️ Menampilkan error sebagai snackbar
  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message.replaceAll('Exception:', '').trim(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
