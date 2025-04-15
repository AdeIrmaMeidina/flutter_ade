import 'package:flutter/material.dart';
import 'package:flutter_ade/app/modules/dashboard/views/berita_view.dart';
import 'package:flutter_ade/app/modules/profile/views/profile_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../views/index_view.dart';

class DashboardController extends GetxController {
  // Menggunakan Rx untuk index yang dipilih
  var selectedIndex = 0.obs;

  // Mengubah index halaman yang dipilih
  void changeIndex(int index) {
    selectedIndex.value = index;

    final _getConnect = GetConnect();

    final token = GetStorage().read('access_token');
  }

  // Daftar halaman yang akan ditampilkan
  final List<Widget> pages = [
    IndexView(),
    BeritaView(),
    ProfileView(),
  ];

  @override
  void onInit() {();
    super.onInit();
    // Anda bisa menambahkan logika inisialisasi tambahan jika diperlukan
  }

  @override
  void onReady() {
    super.onReady();
    // Logika yang dijalankan setelah controller siap
  }

  @override
  void onClose() {
    super.onClose();
    // Jika perlu membersihkan resource, lakukan di sini
  }
}
