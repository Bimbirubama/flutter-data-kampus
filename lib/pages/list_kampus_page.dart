import 'package:flutter/material.dart';
import '../models/kampus_model.dart';
import '../services/api_service.dart';
import 'detail_kampus_page.dart';
import 'form_kampus_page.dart';

class ListKampusPage extends StatefulWidget {
  const ListKampusPage({Key? key}) : super(key: key);

  @override
  State<ListKampusPage> createState() => _ListKampusPageState();
}

class _ListKampusPageState extends State<ListKampusPage> {
  late Future<List<Kampus>> futureKampus;

  @override
  void initState() {
    super.initState();
    futureKampus = ApiService.fetchKampus();
  }

  void _refreshData() {
    setState(() {
      futureKampus = ApiService.fetchKampus();
    });
  }

  void _deleteKampus(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Hapus Kampus'),
        content: Text('Yakin ingin menghapus data kampus ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ApiService.deleteKampus(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kampus berhasil dihapus')),
        );
        _refreshData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus kampus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Daftar Kampus'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<Kampus>>(
        future: futureKampus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.orange));
          }

          if (snapshot.hasError) {
            print('❌ ERROR: ${snapshot.error}');
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Belum ada data kampus.'));
          }

          final kampusList = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: kampusList.length,
            itemBuilder: (context, index) {
              final kampus = kampusList[index];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    kampus.nama,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.orange[800],
                    ),
                  ),
                  subtitle: Text(
                    '${kampus.kategori} • ${kampus.jurusan}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailKampusPage(kampus: kampus),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormKampusPage(
                                kampus: kampus,
                                isEdit: true,
                              ),
                            ),
                          ).then((_) => _refreshData());
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteKampus(kampus.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FormKampusPage(isEdit: false),
            ),
          ).then((_) => _refreshData());
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Kampus',
      ),
    );
  }
}
