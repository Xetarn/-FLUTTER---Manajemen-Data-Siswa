import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DetailSiswaPage extends StatelessWidget {
  final Map<String, dynamic> siswa;

  const DetailSiswaPage({super.key, required this.siswa});

  @override
  Widget build(BuildContext context) {
    final nama = siswa['nama']?.toString() ?? '-';
    final nis = siswa['nis']?.toString() ?? '-';
    final tempatLahir = siswa['tempat_lahir']?.toString() ?? '-';
    final tanggalLahir = siswa['tanggal_lahir']?.toString() ?? '-';
    final jenisKelamin = siswa['jenis_kelamin']?.toString() ?? '-';
    final alamat = siswa['alamat']?.toString() ?? '-';
    final noTelepon = siswa['no_telepon']?.toString() ?? '-';
    final kelas = siswa['kelas']?.toString() ?? '-';
    final jurusan = siswa['jurusan']?.toString() ?? '';
    final fotoUrl = siswa['foto_url']?.toString();
    final spine = AppTokens.spineFor(jurusan);

    return Scaffold(
      backgroundColor: AppTokens.chalk,
      appBar: AppBar(
        title: const Text(
          'Catatan siswa',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student ID card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTokens.rule),
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Container(
                    color: AppTokens.board,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Kartu catatan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(alpha: 0.16),
                            borderRadius:
                                BorderRadius.circular(7),
                            border: Border.all(
                              color: Colors.white
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            jurusan.isEmpty ? kelas : jurusan,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(10),
                          child: Container(
                            width: 84,
                            height: 100,
                            color: AppTokens.chalk,
                            child: fotoUrl != null &&
                                    fotoUrl.isNotEmpty
                                ? Image.network(
                                    fotoUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __,
                                            ___) =>
                                        const Icon(
                                      Icons.person_outline,
                                      size: 36,
                                      color:
                                          AppTokens.muted,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person_outline,
                                    size: 36,
                                    color: AppTokens.muted,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: spine,
                                  borderRadius:
                                      BorderRadius.circular(
                                          2),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                nama,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.w800,
                                  letterSpacing: -0.3,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text('NIS $nis',
                                  style: nisStyle(size: 14)),
                              const SizedBox(height: 4),
                              Text(
                                'Kelas $kelas',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTokens.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: AppTokens.rule),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 8),
              child: Column(
                children: [
                  _row('Tempat lahir', tempatLahir),
                  _row('Tanggal lahir', tanggalLahir),
                  _row('Jenis kelamin', jenisKelamin),
                  _row('Alamat', alamat, lastOfGroup: false),
                  _row('Nomor telepon', noTelepon,
                      last: true),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Periksa ejaan nama dan NIS sebelum mencetak ulang rapor.',
              style: TextStyle(
                  fontSize: 12.5, color: AppTokens.muted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value,
      {bool last = false, bool lastOfGroup = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppTokens.muted,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!last) const Divider(height: 1),
      ],
    );
  }
}
