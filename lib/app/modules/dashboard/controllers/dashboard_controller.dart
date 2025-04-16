import 'package:flutter/material.dart';
import 'package:flutter_ade/app/modules/dashboard/views/berita_view.dart';
import 'package:flutter_ade/app/modules/dashboard/views/profile_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../views/index_view.dart';
import '../../berita/controllers/berita_controller.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    IndexView(),
    BeritaView(),
    ProfileView(),
  ];

  @override
  void onInit() {
    super.onInit();
    // Register BeritaController agar bisa digunakan di BeritaView
    Get.put(BeritaController());
  }
}
