class BeritaResponse {
  bool? success;
  String? message;
  List<Berita>? berita;

  BeritaResponse({this.success, this.message, this.berita});

  factory BeritaResponse.fromJson(Map<String, dynamic> json) {
    return BeritaResponse(
      success: json['success'],
      message: json['message'],
      berita: (json['berita'] as List)
          .map((item) => Berita.fromJson(item))
          .toList(),
    );
  }
}

class Berita {
  int? id;
  String? judulBerita;
  String? deskripsi;
  String? kategori;
  String? image;

  Berita({
    this.id,
    this.judulBerita,
    this.deskripsi,
    this.kategori,
    this.image,
  });

  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      id: json['id'],
      judulBerita: json['judul_berita'],
      deskripsi: json['deskripsi'],
      kategori: json['kategori'],
      image: json['image'],
    );
  }
}
