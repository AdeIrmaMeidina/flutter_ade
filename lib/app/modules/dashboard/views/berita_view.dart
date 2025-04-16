import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ade/app/modules/berita/controllers/berita_controller.dart';
import 'package:get/get.dart';

class BeritaView extends StatelessWidget {
  final BeritaController controller = Get.find(); // Mendapatkan controller

  // Ganti ini sesuai dengan IP atau domain server Laravel kamu
  final String baseUrl = 'http://127.0.0.1:8000/api/berita'; 
  // Untuk emulator Android
  // final String baseUrl = 'http://192.168.1.5:8000'; // Untuk device fisik

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.beritaList.isEmpty) {
          return Center(child: Text('Tidak ada berita tersedia.'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: controller.beritaList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              var berita = controller.beritaList[index];
              // Bangun URL gambar dari server Laravel
              String imageUrl = '$baseUrl/storage/${berita.image ?? ""}';

              return Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, size: 40),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
