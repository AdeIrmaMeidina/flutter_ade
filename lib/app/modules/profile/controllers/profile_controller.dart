import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/profile_response.dart';
import '../../../utils/api.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = Rxn<ProfileResponse>();

  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;
      final token = await storage.read('token');

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Token tidak ditemukan. Silakan login ulang.');
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse(BaseUrl.profile),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        profileData.value =
            ProfileResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        Get.snackbar('Session Expired', 'Silakan login ulang.');
        await logout();
      } else {
        Get.snackbar('Error', 'Gagal ambil profil (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal ambil data profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final token = await storage.read('token');

      if (token == null || token.isEmpty) {
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.post(
        Uri.parse(BaseUrl.logout),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({}),
      );

      if (response.statusCode == 200) {
        Get.offAllNamed('/login');
      } else {
        String message = 'Logout gagal (${response.statusCode})';
        try {
          final error = json.decode(response.body);
          if (error is Map && error['message'] != null) {
            message = error['message'];
          }
        } catch (_) {}
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan saat logout: $e');
    }
  }
}
