import 'package:flutter/material.dart';
import '../../../data/berita_response.dart'; // pastikan path model kamu benar

class BeritaDetailView extends StatelessWidget {
  final Berita berita;

  const BeritaDetailView({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(berita.judulBerita ?? 'Judul Tidak Tersedia'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            if (berita.image != null && berita.image!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  berita.image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 50); // Gambar gagal
                  },
                ),
              ),
            const SizedBox(height: 16),

            // Judul
            Text(
              berita.judulBerita ?? 'Judul Tidak Tersedia',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Deskripsi
            Text(
              berita.deskripsi ?? 'Deskripsi Tidak Tersedia',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Kategori
            Row(
              children: [
                const Icon(Icons.category, size: 20),
                const SizedBox(width: 6),
                Text(
                  berita.kategori ?? 'Kategori Tidak Tersedia',
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
