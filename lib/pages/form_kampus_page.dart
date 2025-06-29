import 'package:flutter/material.dart';
import '../models/kampus_model.dart';
import '../services/api_service.dart';

class FormKampusPage extends StatefulWidget {
  final Kampus? kampus;
  final bool isEdit;

  const FormKampusPage({Key? key, this.kampus, required this.isEdit}) : super(key: key);

  @override
  State<FormKampusPage> createState() => _FormKampusPageState();
}

class _FormKampusPageState extends State<FormKampusPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();

  String _kategori = 'Negeri';

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.kampus != null) {
      _namaController.text = widget.kampus!.nama;
      _alamatController.text = widget.kampus!.alamat;
      _noTelpController.text = widget.kampus!.noTelpon;
      _latController.text = widget.kampus!.latitude.toString();
      _longController.text = widget.kampus!.longitude.toString();
      _jurusanController.text = widget.kampus!.jurusan;
      _kategori = widget.kampus!.kategori;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final kampus = Kampus(
        id: widget.kampus?.id ?? 0,
        nama: _namaController.text,
        alamat: _alamatController.text,
        noTelpon: _noTelpController.text,
        kategori: _kategori,
        latitude: double.parse(_latController.text),
        longitude: double.parse(_longController.text),
        jurusan: _jurusanController.text,
      );

      bool success;
      if (widget.isEdit) {
        success = await ApiService.updateKampus(kampus.id, kampus);
      } else {
        success = await ApiService.addKampus(kampus);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.isEdit ? 'Data diperbarui' : 'Data ditambahkan')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.isEdit ? 'Edit Kampus' : 'Tambah Kampus'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Kampus'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat Lengkap'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _noTelpController,
                decoration: InputDecoration(labelText: 'No Telepon'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              DropdownButtonFormField<String>(
                value: _kategori,
                items: ['Swasta', 'Negeri']
                    .map((kategori) => DropdownMenuItem(
                          value: kategori,
                          child: Text(kategori),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _kategori = value!),
                decoration: InputDecoration(labelText: 'Kategori'),
              ),
              TextFormField(
                controller: _latController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Latitude'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _longController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Longitude'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _jurusanController,
                decoration: InputDecoration(labelText: 'Jurusan (salah satu saja)'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _submitForm,
                child: Text(widget.isEdit ? 'Update' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
