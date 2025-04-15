import 'package:flutter/material.dart';
import 'package:flutter_ade/app/modules/berita/controllers/berita_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BeritaView extends StatelessWidget {
  BeritaView({super.key});

  final beritaController = Get.put(BeritaController());

  final _getConnect = GetConnect();

  final token = GetStorage().read('access_token');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Berita"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Our Berita',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Berita',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // ✅ Expanded hanya di sini
            Expanded(
              child: Obx(() {
                if (beritaController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (beritaController.beritaList.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada berita tersedia.'));
                }

                // ✅ Jangan pakai Expanded lagi di sini!
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: beritaController.beritaList.length,
                  itemBuilder: (context, index) {
                    final berita = beritaController.beritaList[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                // 🛠️ Pastikan URL gambar ini sudah benar ya
                                'http://10.0.2.2:8000/storage/${berita.image ?? ""}',
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              berita.judulBerita ?? 'No Title',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              berita.deskripsi ?? 'No Description',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              berita.kategori ?? 'No Category',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
