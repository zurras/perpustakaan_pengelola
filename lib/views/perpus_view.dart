import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perpustakaan/models/perpus.dart';
import 'package:perpustakaan/controllers/perpus_controller.dart';

void main() => runApp(PerpustakaanApp());

class PerpustakaanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pengelola Perpustakaan',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PerpustakaanScreen(),
    );
  }
}

class PerpustakaanScreen extends StatefulWidget {
  @override
  _PerpustakaanScreenState createState() => _PerpustakaanScreenState();
}

class _PerpustakaanScreenState extends State<PerpustakaanScreen> {
  final PerpustakaanController _controller = PerpustakaanController();

  final _judulController = TextEditingController();
  final _penulisController = TextEditingController();
  final _coverController = TextEditingController();
  final _tahunController = TextEditingController();
  final _halamanController = TextEditingController();

  void _tambahBuku() {
    final judul = _judulController.text;
    final penulis = _penulisController.text;
    final cover = _coverController.text;
    final tahun = int.tryParse(_tahunController.text) ?? 0;
    final halaman = int.tryParse(_halamanController.text) ?? 0;

    setState(() {
      _controller.tambahBuku(Perpus(
        judul: judul,
        penulis: penulis,
        cover: cover,
        tahunTerbit: tahun,
        jumlahHalaman: halaman,
      ));
    });

    _clearControllers();
  }

  void _editBuku(int index) {
    final buku = _controller.getBukuList()[index];

    _judulController.text = buku.judul;
    _penulisController.text = buku.penulis;
    _coverController.text = buku.cover;
    _tahunController.text = buku.tahunTerbit.toString();
    _halamanController.text = buku.jumlahHalaman.toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Buku'),
        content: _bukuForm(),
        actions: [
          TextButton(
            child: Text('Simpan'),
            onPressed: () {
              setState(() {
                _controller.editBuku(
                    index,
                    Perpus(
                      judul: _judulController.text,
                      penulis: _penulisController.text,
                      cover: _coverController.text,
                      tahunTerbit: int.parse(_tahunController.text),
                      jumlahHalaman: int.parse(_halamanController.text),
                    ));
              });
              Navigator.of(context).pop();
              _clearControllers();
            },
          ),
          TextButton(
            child: Text('Batal'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _hapusBuku(int index) {
    setState(() {
      _controller.hapusBuku(index);
    });
  }

  void _clearControllers() {
    _judulController.clear();
    _penulisController.clear();
    _coverController.clear();
    _tahunController.clear();
    _halamanController.clear();
  }

  Widget _bukuForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: _judulController,
              decoration: InputDecoration(labelText: 'Judul')),
          TextField(
              controller: _penulisController,
              decoration: InputDecoration(labelText: 'Penulis')),
          TextField(
              controller: _coverController,
              decoration: InputDecoration(labelText: 'Nama Poster')),
          TextField(
            controller: _tahunController,
            decoration: InputDecoration(labelText: 'Tahun Terbit'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            controller: _halamanController,
            decoration: InputDecoration(labelText: 'Jumlah Halaman'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengelola Perpustakaan')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _bukuForm(),
            ElevatedButton(
              onPressed: _tambahBuku,
              child: Text('Tambah Buku'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _controller.getBukuList().length,
                itemBuilder: (context, index) {
                  final buku = _controller.getBukuList()[index];
                  return ListTile(
                    leading: Image(image: AssetImage("cover/" + buku.cover)),
                    title: Text(buku.judul),
                    subtitle: Text(
                      'Penulis: ${buku.penulis}, Tahun: ${buku.tahunTerbit}, Halaman: ${buku.jumlahHalaman}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editBuku(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _hapusBuku(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
