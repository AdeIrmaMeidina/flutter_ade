import 'package:flutter_ade/app/modules/berita/controllers/berita_controller.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController()); // ✅ controller utama
    Get.put(BeritaController()); // ✅ controller berita (penting!)
  }
}
