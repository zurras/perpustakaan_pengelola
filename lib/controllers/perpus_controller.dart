import 'package:perpustakaan/models/perpus.dart';

class PerpustakaanController {
  List<Perpus> bukuList = [];

  void tambahBuku(Perpus buku) {
    bukuList.add(buku);
  }

  void editBuku(int index, Perpus buku) {
    bukuList[index] = buku;
  }

  void hapusBuku(int index) {
    bukuList.removeAt(index);
  }

  List<Perpus> getBukuList() {
    return bukuList;
  }
}
