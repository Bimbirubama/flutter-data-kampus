import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/kampus_model.dart';

class DetailKampusPage extends StatelessWidget {
  final Kampus kampus;

  const DetailKampusPage({Key? key, required this.kampus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LatLng lokasiKampus = LatLng(kampus.latitude, kampus.longitude);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(kampus.nama),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            kampus.nama,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Alamat: ${kampus.alamat}'),
          SizedBox(height: 4),
          Text('No. Telepon: ${kampus.noTelpon}'),
          SizedBox(height: 4),
          Text('Kategori: ${kampus.kategori}'),
          SizedBox(height: 4),
          Text('Jurusan: ${kampus.jurusan}'),
          SizedBox(height: 16),
          Text(
            'Lokasi Kampus',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: lokasiKampus,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(kampus.nama),
                    position: lokasiKampus,
                    infoWindow: InfoWindow(title: kampus.nama),
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
