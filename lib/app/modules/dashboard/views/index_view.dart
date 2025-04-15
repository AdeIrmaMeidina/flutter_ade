import 'package:flutter/material.dart';
import 'package:flutter_ade/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'berita_detail_view.dart';
import 'package:flutter_ade/app/modules/berita/controllers/berita_controller.dart';

class IndexView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Pastikan controller yang digunakan benar
    final dashboardController = Get.find<DashboardController>();
    final beritaController = Get.find<BeritaController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Berita'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (beritaController.isLoading.value) {
          // Menampilkan animasi loading saat data masih dimuat
          return Center(
            child: Lottie.network(
              'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
              width: MediaQuery.of(context).size.width,
            ),
          );
        }

        if (beritaController.beritaList.isEmpty) {
          // Menampilkan pesan jika tidak ada data
          return const Center(child: Text("Tidak ada data"));
        }

        // Menampilkan daftar berita
        return ListView.builder(
          itemCount: beritaController.beritaList.length,
          itemBuilder: (context, index) {
            final berita = beritaController.beritaList[index];
            return ZoomTapAnimation(
              onTap: () {
                // Navigasi ke halaman detail berita
                Get.to(() => BeritaDetailView(berita: berita));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan gambar berita
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      berita.image ?? "", // Gunakan gambar dari model berita
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                            Icons.error); // Jika gambar gagal dimuat
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Menampilkan judul berita
                  Text(
                    berita.judulBerita ?? 'No Title', // Judul berita
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Menampilkan deskripsi berita
                  Text(
                    berita.deskripsi ?? 'No Description', // Deskripsi berita
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Menampilkan kategori berita
                  Row(
                    children: [
                      const Icon(Icons.category, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        berita.kategori ?? 'No Category', // Kategori berita
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
