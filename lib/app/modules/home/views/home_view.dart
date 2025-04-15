import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
Widget build(BuildContext context) {
  HomeController controller = Get.put(HomeController());

  return Scaffold(  // Membuat struktur utama tampilan aplikasi dengan widget Scaffold
    backgroundColor: HexColor('#feeee8'),  // Menentukan warna latar belakang Scaffold dengan kode warna heksadesimal
    body: Center(  // Membuat widget Center sebagai kontainer untuk widget Column
      child: Column(  // Membuat widget Column sebagai tampilan vertikal
        mainAxisAlignment: MainAxisAlignment.center,  // Menentukan posisi tampilan vertikal pada tengah halaman
        crossAxisAlignment: CrossAxisAlignment.center,  // Menentukan posisi tampilan horizontal pada tengah halaman
        children: [  // Widget turunan dari widget Column
          Lottie.network(  // Widget Lottie untuk menampilkan animasi Lottie dengan sumber dari internet
            'https://gist.githubusercontent.com/olipiskandar/2095343e6b34255dcfb042166c4a3283/raw/d76e1121a2124640481edcf6e7712130304d6236/praujikom_kucing.json',
            fit: BoxFit.cover,  // Menentukan ukuran dan posisi animasi Lottie pada tampilan
          ),
          const SizedBox(  // Widget SizedBox untuk memberikan jarak antar widget
            height: 15,  // Menentukan jarak vertikal antara widget Lottie dan Text
          ),
          Text(  // Widget Text untuk menampilkan teks pada tampilan aplikasi
            'Aplikasi Portal Berita Indonesia',  // Isi teks pada widget Text
            style: GoogleFonts.roboto(  // Menggunakan font Google Roboto pada widget Text
              textStyle: const TextStyle(  // Styling pada widget Text
                fontWeight: FontWeight.bold,  // Menentukan ketebalan font pada teks
                fontSize: 30,  // Menentukan ukuran font pada teks
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}