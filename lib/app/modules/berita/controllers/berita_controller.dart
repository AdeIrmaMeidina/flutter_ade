import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_ade/app/data/berita_response.dart';
import 'package:flutter_ade/app/utils/api.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';

class BeritaController extends GetxController {
  var isLoading = false.obs;
  var beritaList  = <Berita>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBerita(); // langsung panggil saat controller diinisialisasi
  }

  Future<String?> getToken() async {
    final box = GetStorage();
    return box.read('token');
  }

  Future<void> fetchBerita() async {
    try {
      isLoading.value = true;
      String? token = await getToken();
     String fullUrl = '${BaseUrl.baseUrl}${BaseUrl.berita}'; // ganti sesuai endpoint yang benar

      debugPrint("📡 Fetching: $fullUrl");
      debugPrint("🔑 Token: $token");

     final response = await GetConnect().get(
        fullUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );


      debugPrint("📦 Response status: ${response.statusCode}");
      debugPrint("📦 Response body: ${response.body}");

      if (response.statusCode == 401) {
        Get.offAllNamed('/login');
        return;
      }

      if (response.body == null || response.body['berita'] == null) {
        beritaList.clear();
        debugPrint("⚠️ Tidak ada data berita.");
        return;
      }

      final List<dynamic> data = response.body['berita'];
      beritaList.assignAll(data.map((e) => Berita.fromJson(e)).toList());

      debugPrint("✅ Jumlah berita: ${beritaList.length}");
    } catch (e) {
      debugPrint("❌ Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
