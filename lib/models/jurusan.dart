class Jurusan {
  final int idJurusan;
  final String namaJurusan;

  Jurusan(this.idJurusan,this.namaJurusan);

  factory Jurusan.fromJson(Map<String, dynamic> json) {
    return Jurusan(
      json['idJurusan'],
      json['namaJurusan'],
    );
  }

  Map<String, dynamic> toJson() => {
    'idJurusan': idJurusan,
    'namaJurusan': namaJurusan,
  };
}