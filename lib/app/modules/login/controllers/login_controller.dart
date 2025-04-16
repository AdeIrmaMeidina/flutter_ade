import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utils/api.dart';
import '../../dashboard/views/dashboard_view.dart';

class LoginController extends GetxController {
  final _getConnect = GetConnect();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final storage = GetStorage();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void loginNow() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validasi input
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Login Failed',
        'Email dan password tidak boleh kosong.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.warning),
      );
      return;
    }

    // Kirim request ke server
    final response = await _getConnect.post(BaseUrl.login, {
      'email': email,
      'password': password,
    });

    // Jika login berhasil
    if (response.statusCode == 200) {
      // Ambil token dari response dan simpan ke storage
      final accessToken = response.body['access_token'];

      if (accessToken != null) {
        storage.write('token', accessToken); // Menyimpan token
        storage.write('user', response.body['user']); // Menyimpan data user

        // Pindah ke dashboard
        Get.offAll(() => const DashboardView());
      } else {
        Get.snackbar(
          'Login Failed',
          'Token tidak ditemukan dalam respons.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.warning),
        );
      }
    } else {
      // Jika gagal login
      Get.snackbar(
        'Login Gagal',
        response.body['message']?.toString() ?? 'Terjadi kesalahan.',
        icon: const Icon(Icons.error),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        forwardAnimationCurve: Curves.bounceIn,
      );
    }
  }
}
