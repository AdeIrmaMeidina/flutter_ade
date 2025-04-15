import 'dart:io';

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

    try {
      // Kirim request ke server
      final response = await _getConnect.post(BaseUrl.login, {
        'email': email,
        'password': password,
      }).timeout(
        const Duration(
            seconds: 20), // Menambahkan timeout jika server tidak merespons
        onTimeout: () {
          return Response(statusCode: 408, body: 'Timeout Error');
        },
      );

      // Jika login berhasil
      if (response.statusCode == 200) {
        final body = response.body;
        if (body != null && body is Map<String, dynamic>) {
          final accessToken = body['access_token'];
          final user = body['user'];

          if (accessToken != null) {
            // Simpan token dan data user ke storage
            storage.write('token', accessToken);
            storage.write('user', user);

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
          Get.snackbar(
            'Login Failed',
            'Respons tidak valid. Silakan coba lagi.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.warning),
          );
        }
      } else {
        // Jika gagal login, tampilkan pesan error
        final message =
            response.body['message']?.toString() ?? 'Terjadi kesalahan.';
        Get.snackbar(
          'Login Gagal',
          message,
          icon: const Icon(Icons.error),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          forwardAnimationCurve: Curves.bounceIn,
        );
      }
    } catch (e) {
      // Tangani error jaringan atau masalah lainnya
      if (e is SocketException) {
        Get.snackbar(
          'Login Error',
          'Tidak ada koneksi internet. Pastikan Anda terhubung ke internet.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error),
        );
      } else {
        Get.snackbar(
          'Login Error',
          'Terjadi kesalahan saat menghubungi server: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error),
        );
      }
    }
  }
}
