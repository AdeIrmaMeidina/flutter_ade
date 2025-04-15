class BeritaResponse {
  bool? success;
  String? message;
  List<Berita>? berita;

  BeritaResponse({this.success, this.message, this.berita});

  BeritaResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['berita'] != null) {
      berita = <Berita>[];
      json['berita'].forEach((v) {
        berita!.add(new Berita.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.berita != null) {
      data['berita'] = this.berita!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Berita {
  int? id;
  String? judulBerita;
  String? deskripsi;
  String? kategori;
  String? image;
  String? createdAt;
  String? updatedAt;

  Berita(
      {this.id,
      this.judulBerita,
      this.deskripsi,
      this.kategori,
      this.image,
      this.createdAt,
      this.updatedAt});

  Berita.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    judulBerita = json['judul_berita'];
    deskripsi = json['deskripsi'];
    kategori = json['kategori'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['judul_berita'] = this.judulBerita;
    data['deskripsi'] = this.deskripsi;
    data['kategori'] = this.kategori;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
